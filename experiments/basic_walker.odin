package experiments

import "core:math/rand"

import rl "vendor:raylib"

TILE_SIZE :: 4
MENU_BAR_HEIGHT :: 80

Walker :: struct {
	x, y: i32,
}

rng := rand.default_random_generator()

step :: proc(w: ^Walker) {
	dir := rand.int_range(0, 4, rng)
	switch dir {
	case 0:
		w.y -= 1
	case 1:
		w.x += 1
	case 2:
		w.y += 1
	case 3:
		w.x -= 1
	}
}

// need to draw to canvas to avoid dubble buffer issues
// while accumulating draws
canvas: rl.RenderTexture2D

walker: Walker

basic_walker :: Screen {
	init   = basic_walker_init,
	update = basic_walker_update,
}

basic_walker_init :: proc() {
	walker = Walker{rl.GetScreenWidth() / 2, rl.GetScreenHeight() / 2}

	if canvas.id != 0 do rl.UnloadRenderTexture(canvas)
	canvas = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())

	rl.BeginTextureMode(canvas)
	rl.ClearBackground(rl.RAYWHITE)
	rl.EndTextureMode()
}

basic_walker_deinit :: proc() {
	rl.UnloadRenderTexture(canvas)
}

basic_walker_update :: proc(back: proc()) {
	step(&walker)

	rl.BeginTextureMode(canvas)
	rl.DrawRectangle(walker.x, walker.y, TILE_SIZE, TILE_SIZE, rl.BLACK)
	rl.EndTextureMode()

	rl.BeginDrawing()
	rl.ClearBackground(rl.RAYWHITE)

	rl.DrawTextureRec(
		canvas.texture,
		rl.Rectangle{0, 0, f32(canvas.texture.width), -f32(canvas.texture.height)},
		rl.Vector2{0, 0},
		rl.WHITE,
	)

	// UI over the walker
	if rl.GuiLabelButton(rl.Rectangle{20, 20, 40, 40}, "back") do back()

	rl.EndDrawing()
}
