pub let cell_size = 8
// pub let cell_size = 10
// pub let cell_size = 16
pub let number_of_pixels = 160
pub let speed = 10

// may need a better name... just means number of cells wide and high i.e. 10x10 would be board_size = 10
pub let board_size: Int = (number_of_pixels / cell_size)
pub let initial_cell_count: Int = ((board_size * board_size).to_double() * 0.9).to_int()