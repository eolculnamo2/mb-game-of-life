let r: @random.RandomState = @random.init_state(~seed=1000)
pub struct BoardTime {
  // increases each time update function is called (at 60 hz)
  mut current_frame: Int
}
pub struct Board {
  mut time: BoardTime
  mut can_click: Bool
  mut cells: Array[Cell]
}

fn generate_double() -> Double {
  let n = r.gen_double()
  if n > 1 {
    n - 1
  } else {
    n
  }
}

fn init_cells() -> Array[Cell] {
  let mut live_cells_left = initial_cell_count

  let cells: Array[Cell] = []

  let mut placement = 0 
  for i = 0; i < board_size; i = i + 1 {
    for j = 0; j < board_size; j = j + 1 {
        let random_id = r.gen_int()
        cells.push(Cell::make(
          ~id=random_id,
          ~x=scale_coordinate(i),
          ~y=scale_coordinate(j),
          ~placement, 
        ))
        placement += 1
      }
  }

  while live_cells_left > 0 {
    let i = (generate_double() * cells.length().to_double()).to_int()
    let _ = cells.get(i).map(fn (c) {
        c.is_alive = true
    })
    live_cells_left-=1
  }
  cells
}

pub fn play_generation(self: Board) -> Unit {
  let new_cells = self.cells.map(fn(c) {
    let neighbor_count = [
        c.placement - board_size - 1, // TOP_LEFT
        c.placement - board_size,  // TOP_CENTER
        c.placement - board_size + 1, // TOP_RIGHT
        c.placement - 1, // LEFT
        c.placement + 1, // RIGHT
        c.placement + board_size - 1, // BOTTOM_LEFT
        c.placement + board_size, // BOTTOM_CENTER
        c.placement + board_size + 1, // BOTTOM_RIGHT
    ].fold_left(~init=0, fn (sum, cell_index) {
        let is_neighbor_alive = self.cells.get(cell_index).map_or(false, fn(c) {
          c.is_alive
        })
        if is_neighbor_alive {
          sum + 1
        } else{ 
          sum
        }
    })

    let will_live = match (neighbor_count, c.is_alive) {
      (2 | 3, true) => true
      (3, false) =>  true
      _ => false
    }
    {..c, is_alive: will_live }
  })
  self.cells = new_cells
}

pub fn Board::increment_frame(self: Board) -> Unit  {
  self.time.current_frame += 1
}

pub fn Board::should_make_new_generation(self: Board) -> Bool  {
  self.time.current_frame % speed == 0
}

pub fn Board::make() -> Board {
  let board: Board = {
    cells: [],
    can_click: true,
    time: { current_frame: 0  },
   }
   let initialized_cells = init_cells()

   {..board, cells: initialized_cells }
}
