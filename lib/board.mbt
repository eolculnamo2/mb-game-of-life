pub let board_size = 160
pub let initial_cell_count = 1300
let r: @random.RandomState = @random.init_state(~seed=1000)
pub struct BoardTime {
  // increases each time update function is called (at 60 hz)
  mut current_frame: Int
}
pub struct Board {
  mut time: BoardTime
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
  let mut cells_left = initial_cell_count

  // bummer that this doesnt need mut keyword! :(
  let cells: Array[Cell] = []

  while cells_left > 0 {
    // let random_id = floor(random() * 1_000_000.)
    let random_id = r.gen_int()

    // TODO would be correct to prevent overlap two cells at same location
    // let random_x = floor(random() * board_size.to_double())
    // let random_y = floor(random() * board_size.to_double())
    let random_x = (generate_double() * board_size.to_double()).to_int()
    let random_y = (generate_double() * board_size.to_double()).to_int()

    let c = Cell::make(
      ~id=random_id,
      ~x=random_x,
      ~y=random_y,
      )

    cells.push(c)
    cells_left-=1
  }

  cells
}

pub fn play_generation(self: Board) -> Unit {
  self.cells.map_inplace(fn(c) {
    let random_x = (generate_double() * board_size.to_double()).to_int()
    let random_y = (generate_double() * board_size.to_double()).to_int()

    // TODO this next
    // let mut neighbor_count = 0
    // top left
    // top center
    // top right
    // left
    // right
    // bottom left
    // bottom center
    // bottom right

    c.x = random_x
    c.y = random_y
    c
  })
}


pub fn Board::increment_frame(self: Board) -> Unit  {
  self.time.current_frame += 1
}

pub fn Board::should_make_new_generation(self: Board) -> Bool  {
  self.time.current_frame % 20 == 0
}

pub fn Board::make() -> Board {
  {  cells: init_cells(), time: { current_frame: 0 }  }
}
