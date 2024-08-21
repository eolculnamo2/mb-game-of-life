pub struct Cell {
  id: Int
  placement: Int
  mut is_alive: Bool
  mut x: Int
  mut y: Int
}

pub fn scale_coordinate(coordinate: Int) -> Int {
  cell_size * coordinate
}

pub fn Cell::make(~id: Int, ~x: Int, ~y: Int, ~placement: Int) -> Cell {
  { id, x, y, is_alive: false, placement }
}