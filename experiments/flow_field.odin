package experiments

import "core:math/noise"
import "core:math/rand"

import rl "vendor:raylib"

flow_field :: Screen {
	init   = flow_field_init,
	deinit = flow_field_deinit,
	update = flow_field_update,
}

SCALE :: 8

Field :: struct {
	rows, cols: int,
	arr:        [][2]f32, // flat grid, indexed [y*cols + x]
}

f: Field

field_at :: proc(f: ^Field, x, y: int) -> ^[2]f32 {
	return &f.arr[y * f.cols + x]
}

flow_field_init :: proc() {
	f.rows = int(rl.GetScreenHeight()) / SCALE
	f.cols = int(rl.GetScreenWidth()) / SCALE
	f.arr = make([][2]f32, f.rows * f.cols)
}

flow_field_deinit :: proc() {
	delete(f.arr)
	f = {}
}

flow_field_update :: proc(back: proc()) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.RAYWHITE)

	// UI
	if rl.GuiLabelButton(rl.Rectangle{20, 20, 40, 40}, "back") do back()

	rl.EndDrawing()
}
