let board: @lib.Board = @lib.Board::make()

pub fn start() -> Unit {
}


pub fn update() -> Unit {
  board.cells.each(fn (c) {
    @wasm4.set_draw_colors(index=1, if c.is_alive {
          3
        } else {
          0
        })
    @wasm4.rect(c.x, c.y, @lib.cell_size, @lib.cell_size)
  })

  // if @wasm4.get_gamepad(index=1).button_right && board.can_click {
  // board.can_click = false
  if board.should_make_new_generation() {
    board.play_generation()
  }
  board.increment_frame()
  // } 

// if @wasm4.get_gamepad(index=1).button_left {
//   board.can_click = true
// }
}