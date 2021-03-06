
{-# LANGUAGE   RecordWildCards
             , ForeignFunctionInterface
             , TemplateHaskell
             , BangPatterns
             , FlexibleContexts #-}

module RustNBodyExperiment ( RustNBodyExperiment
                           ) where

import Control.Monad.IO.Class
import Control.Lens
import Control.Monad
import Control.Monad.State.Class
import Foreign.C.Types
import Foreign.Ptr
import Data.Word
import Data.Maybe
import Text.Printf
import qualified Data.Vector.Storable.Mutable as VSM
import qualified Graphics.UI.GLFW as GLFW

import Experiment
import FrameBuffer
import Timing
import qualified BoundedSequence as BS
import Median
import GLFWHelpers

-- N-Body Simulation

data RustNBodyExperiment = RustNBodyExperiment
    { _rnbNumSteps   :: !Int
    , _rnbTimes      :: !(BS.BoundedSequence Double)
    , _rnbTimeStep   :: !Double
    , _rnbTheta      :: !Double
    , _rnbNumThreads :: !Int
    }

makeLenses ''RustNBodyExperiment
instance Experiment RustNBodyExperiment where
    withExperiment f = do liftIO $ nbStableOrbits 10000 0.5 30.0
                          f $ RustNBodyExperiment { _rnbNumSteps   = 0
                                                  , _rnbTimes      = BS.empty 30
                                                  , _rnbTimeStep   = 0.01
                                                  , _rnbTheta      = 0.85
                                                  , _rnbNumThreads = 1
                                                  }
    experimentName _ = "RustNBody"
    experimentDraw fb _tick = do
        dt       <- use rnbTimeStep
        theta    <- use rnbTheta
        nthreads <- use rnbNumThreads
        -- Simulate first
        time <- fst <$> liftIO (timeIt $ nbStepBarnesHut (realToFrac theta)
                                                         (realToFrac dt)
                                                         (fromIntegral nthreads))
        void . liftIO . fillFrameBuffer fb $ \w h vec ->
            VSM.unsafeWith vec $ \pvec ->
                nbDraw (fromIntegral w) (fromIntegral h) pvec
        rnbNumSteps += 1
        rnbTimes    %= BS.push_ time
    experimentStatusString = do
        RustNBodyExperiment { .. } <- get
        let avgtime = fromMaybe 1 . median . BS.toList $ _rnbTimes
        np <- liftIO (fromIntegral <$> nbNumParticles :: IO Int)
        return $ printf ( "%i Steps, %.1fSPS/%.2fms | %s Bodies\n" ++
                         "[QWE] Scene | Time Step [X][x]: %.4f | Theta [A][a]: %.2f | " ++
                         "Threads [P][p]: %i"
                        )
                        _rnbNumSteps
                        (1 / avgtime)
                        (avgtime * 1000)
                        ( if   np > 999
                          then show (np `div` 1000) ++ "K"
                          else show np
                        )
                        _rnbTimeStep
                        _rnbTheta
                        _rnbNumThreads
    experimentGLFWEvent ev = do
        case ev of
            GLFWEventKey _win k _sc ks mk | ks == GLFW.KeyState'Pressed ->
                case k of
                    GLFW.Key'Q -> liftIO $ nbStableOrbits 10000 0.5 30.0
                    GLFW.Key'W -> liftIO $ nbRandomDisk   10000
                    GLFW.Key'E -> liftIO $ nbStableOrbits 5 5.0 40.0
                    GLFW.Key'X | GLFW.modifierKeysShift mk -> rnbTimeStep //= 2
                               | otherwise                 -> rnbTimeStep  *= 2
                    GLFW.Key'A | GLFW.modifierKeysShift mk ->
                                     rnbTheta %= max 0.0 . min 0.95 . (\x -> x - 0.05)
                               | otherwise                 ->
                                     rnbTheta %= max 0.0 . min 0.95 . (\x -> x + 0.05)
                    GLFW.Key'P | GLFW.modifierKeysShift mk ->
                                     rnbNumThreads %= max 1 . min 16 . pred
                               | otherwise                 ->
                                     rnbNumThreads %= max 1 . min 16 . succ
                    _          -> return ()
            _ -> return ()

foreign import ccall "nb_draw"             nbDraw            :: CInt -> CInt -> Ptr Word32 -> IO ()
foreign import ccall "nb_step_brute_force" _nbStepBruteForce :: CFloat -> IO ()
foreign import ccall "nb_step_barnes_hut"  nbStepBarnesHut   :: CFloat -> CFloat -> CInt -> IO ()
foreign import ccall "nb_random_disk"      nbRandomDisk      :: CInt -> IO ()
foreign import ccall "nb_stable_orbits"    nbStableOrbits    :: CInt -> CFloat -> CFloat -> IO ()
foreign import ccall "nb_num_particles"    nbNumParticles    :: IO CInt

