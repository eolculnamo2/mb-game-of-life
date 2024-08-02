// moon build --target wasm
// npx wasm4 run target/wasm/release/build/demo.wasm

let board: @lib.Board = @lib.Board::make()

pub fn start() -> Unit {
}

pub fn update() -> Unit {
  @wasm4.text("Moonbit\nGame of life", 10, 10)

  @wasm4.set_draw_colors(index=1, 3)
  board.cells.each(fn (c) {
    @wasm4.rect(c.x, c.y, @lib.cell_size, @lib.cell_size)
  })

  if board.should_make_new_generation() {
    board.play_generation()
  }
  board.increment_frame()
}