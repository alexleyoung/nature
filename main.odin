package main

import rl "vendor:raylib"

import "experiments"

WIDTH :: 640
HEIGHT :: 640

SCREEN :: enum {
	MENU,
	BASIC_WALKER,
}

screen := SCREEN.MENU

return_to_menu :: proc() {
	screen = .MENU
}

screens := [SCREEN]experiments.Screen {
	.MENU = {update = main_menu_render},
	.BASIC_WALKER = experiments.basic_walker,
}

main :: proc() {
	rl.InitWindow(WIDTH, HEIGHT, "nature")
	rl.GuiSetStyle(.DEFAULT, i32(rl.GuiDefaultProperty.TEXT_SIZE), 32)

	active := SCREEN(-1)

	main_loop: for !rl.WindowShouldClose() {
		if screen != active {
			active = screen
			if init := screens[active].init; init != nil do init(return_to_menu)
		}

		screens[screen].update(return_to_menu)
	}
}

// Menu refreshes every frame, so it clears in render.
main_menu_render :: proc(back: proc()) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.RAYWHITE)

	// title
	rl.DrawText("nature", 20, 20, 48, rl.BLACK)
	// experiments
	if rl.GuiLabelButton(rl.Rectangle{30, 80, 100, 40}, "basic walker") do screen = .BASIC_WALKER

	rl.EndDrawing()
}
