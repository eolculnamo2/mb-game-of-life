// increasing this number too much causes an error
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

fn init_cells(self: Board) -> Array[Cell] {
  let mut live_cells_left = initial_cell_count

  // bummer that this doesnt need mut keyword! :(
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
    let result = cells.get(i).map(fn (c) {
        c.is_alive = true
    })
    live_cells_left-=1
  }
  cells
}

pub fn play_generation(self: Board) -> Unit {
  let new_cells = self.cells.map(fn(c) {

    // TODO this next
    let mut neighbor_count = 0
    let top_left= self.cells.get(c.placement - board_size - 1).map_or(false, fn(c) {
      if c.is_alive {
        neighbor_count += 1
      }
      c.is_alive
    })
    let top_center= self.cells.get(c.placement - board_size).map_or(false, fn(c) {
      if c.is_alive {
        neighbor_count += 1
      }
      c.is_alive
    })
    let top_right= self.cells.get(c.placement - board_size + 1).map_or(false, fn(c) {
      if c.is_alive {
        neighbor_count += 1
      }
      c.is_alive
    })
    let right = self.cells.get(c.placement - 1).map_or(false, fn(c) {
      if c.is_alive {
        neighbor_count += 1
      }
      c.is_alive
    })
    let left = self.cells.get(c.placement + 1).map_or(false, fn(c) {
      if c.is_alive {
        neighbor_count += 1
      }
      c.is_alive
    })
    let bottom_left = self.cells.get(c.placement + board_size - 1).map_or(false, fn(c) {
      if c.is_alive {
        neighbor_count += 1
      }
      c.is_alive
    })
    let bottom_center = self.cells.get(c.placement + board_size).map_or(false, fn(c) {
      if c.is_alive {
        neighbor_count += 1
      }
      c.is_alive
    })
    let bottom_right = self.cells.get(c.placement + board_size + 1).map_or(false, fn(c) {
      if c.is_alive {
        neighbor_count += 1
      }
      c.is_alive
    })
      // are when/if clauses supported? 
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
   let initialized_cells = init_cells(board)

   {..board, cells: initialized_cells }
}
