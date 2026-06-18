package experiments

import rl "vendor:raylib"

render_basic_walker :: proc(rtm: proc()) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.RAYWHITE)
	if rl.GuiLabelButton(rl.Rectangle{20, 20, 40, 40}, "back") do rtm()
	rl.EndDrawing()
}
