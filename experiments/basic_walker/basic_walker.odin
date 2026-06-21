package basic_walker

import "core:math/rand"

import exp "nature:experiments"
import rl "vendor:raylib"

TILE_SIZE :: 4
MENU_BAR_HEIGHT :: 80

Walker :: struct {
	x, y: i32,
}

step :: proc(w: ^Walker) {
	dir := rand.int_range(0, 4)
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

canvas: rl.RenderTexture2D

walker: Walker

Screen :: exp.Screen {
	init   = init,
	deinit = deinit,
	update = update,
}

init :: proc() {
	walker = Walker{rl.GetScreenWidth() / 2, rl.GetScreenHeight() / 2}

	if canvas.id != 0 do rl.UnloadRenderTexture(canvas)
	canvas = rl.LoadRenderTexture(rl.GetScreenWidth(), rl.GetScreenHeight())

	rl.BeginTextureMode(canvas)
	rl.ClearBackground(rl.RAYWHITE)
	rl.EndTextureMode()
}

deinit :: proc() {
	rl.UnloadRenderTexture(canvas)
}

update :: proc() -> exp.Transition {
	step(&walker)

	rl.BeginTextureMode(canvas)
	rl.DrawRectangle(walker.x, walker.y, TILE_SIZE, TILE_SIZE, rl.BLACK)
	rl.EndTextureMode()

	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.RAYWHITE)

	rl.DrawTextureRec(
		canvas.texture,
		rl.Rectangle{0, 0, f32(canvas.texture.width), -f32(canvas.texture.height)},
		rl.Vector2{0, 0},
		rl.WHITE,
	)

	if rl.GuiLabelButton(rl.Rectangle{20, 20, 40, 40}, "back") do return .BACK

	return .NONE
}
