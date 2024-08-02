pub let cell_size = 1
pub struct Cell {
  id: Int
  mut x: Int
  mut y: Int
}

pub fn Cell::make(~id: Int, ~x: Int, ~y: Int) -> Cell {
  { id, x, y }
}