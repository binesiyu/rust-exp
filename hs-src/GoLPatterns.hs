
module GoLPatterns ( acorn
                   , gun
                   , spacefill
                   , ark
                   ) where

acorn, gun, spacefill, ark :: [String]

acorn = [ ".O....."
        , "...O..."
        , "OO..OOO"
        ]

gun = [ "........................O..........."
      , "......................O.O..........."
      , "............OO......OO............OO"
      , "...........O...O....OO............OO"
      , "OO........O.....O...OO.............."
      , "OO........O...O.OO....O.O..........."
      , "..........O.....O.......O..........."
      , "...........O...O...................."
      , "............OO......................"
      ]

-- http://www.radicaleye.com/lifepage/patterns/max.html
spacefill = [ ".....O.O....................."
            , "....O..O....................."
            , "...OO........................"
            , "..O.........................."
            , ".OOOO........................"
            , "O....O......................."
            , "O..O........................."
            , "O..O........................."
            , ".O.........OOO...OOO........."
            , "..OOOO.O..O..O...O..O........"
            , "...O...O.....O...O..........."
            , "....O........O...O..........."
            , "....O.O......O...O..........."
            , "............................."
            , "...OOO.....OOO...OOO........."
            , "...OO.......O.....O.........."
            , "...OOO......OOOOOOO.........."
            , "...........O.......O........."
            , "....O.O...OOOOOOOOOOO........"
            , "...O..O..O............OO....."
            , "...O.....OOOOOOOOOOOO...O...."
            , "...O...O.............O...O..."
            , "....O...OOOOOOOOOOOO.....O..."
            , ".....OO............O..O..O..."
            , "........OOOOOOOOOOO...O.O...."
            , ".........O.......O..........."
            , "..........OOOOOOO......OOO..."
            , "..........O.....O.......OO..."
            , ".........OOO...OOO.....OOO..."
            , "............................."
            , "...........O...O......O.O...."
            , "...........O...O........O...."
            , "...........O...O.....O...O..."
            , "........O..O...O..O..O.OOOO.."
            , ".........OOO...OOO.........O."
            , ".........................O..O"
            , ".........................O..O"
            , ".......................O....O"
            , "........................OOOO."
            , "..........................O.."
            , "........................OO..."
            , ".....................O..O...."
            , ".....................O.O....."
            ]

-- http://www.argentum.freeserve.co.uk/lex_a.htm#ark
ark =
    [ "...........................O...."
    , "............................O..."
    , ".............................O.."
    , "............................O..."
    , "...........................O...."
    , ".............................OOO"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "................................"
    , "OO.............................."
    , "..O............................."
    , "..O............................."
    , "...OOOO........................."
    ]

