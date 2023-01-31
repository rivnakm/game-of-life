namespace GameOfLife

module Board = 
    type Board = 
        struct
            val cells:bool[,]
            val height:int
            val width:int

            new (height:int, width:int, cells:bool[,]) =
                { height = height; width = width; cells = cells }
        end