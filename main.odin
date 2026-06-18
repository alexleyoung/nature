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

main :: proc() {
	rl.InitWindow(WIDTH, HEIGHT, "nature")
	rl.GuiSetStyle(.DEFAULT, i32(rl.GuiDefaultProperty.TEXT_SIZE), 32)

	screen_map := [SCREEN]proc(_: proc()) {
		.MENU         = main_menu_screen,
		.BASIC_WALKER = experiments.render_basic_walker,
	}

	main_loop: for !rl.WindowShouldClose() {
		screen_map[screen](return_to_menu)
	}
}

main_menu_screen := proc(_: proc()) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.RAYWHITE)

	// title
	rl.DrawText("nature", 20, 20, 48, rl.BLACK)
	// experiments
	if rl.GuiLabelButton(rl.Rectangle{30, 80, 100, 40}, "basic walker") do screen = .BASIC_WALKER

	rl.EndDrawing()

}
