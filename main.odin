package main

import rl "vendor:raylib"

import "experiments"

WIDTH :: 640
HEIGHT :: 640

SCREEN :: enum {
	MENU,
	BASIC_WALKER,
	FLOW_FIELD,
}

screen := SCREEN.MENU

screens := [SCREEN]experiments.Screen {
	.MENU = {update = main_menu_render},
	.BASIC_WALKER = experiments.basic_walker,
	.FLOW_FIELD = experiments.flow_field,
}

main :: proc() {
	rl.InitWindow(WIDTH, HEIGHT, "nature")
	rl.GuiSetStyle(.DEFAULT, i32(rl.GuiDefaultProperty.TEXT_SIZE), 32)

	active := SCREEN(-1)

	main_loop: for !rl.WindowShouldClose() {
		if screen != active {
			if active != SCREEN(-1) {
				if deinit := screens[active].deinit; deinit != nil do deinit()
			}
			active = screen
			if init := screens[active].init; init != nil do init()
		}

		switch screens[screen].update() {
		case .NONE:
		case .BACK:
			screen = .MENU
		}
	}
}

// Menu refreshes every frame, so it clears in render.
main_menu_render :: proc() -> experiments.Transition {
	rl.BeginDrawing()
	rl.ClearBackground(rl.RAYWHITE)

	// title
	rl.DrawText("nature", 20, 20, 48, rl.BLACK)
	// experiments
	if rl.GuiLabelButton(rl.Rectangle{30, 80, 100, 40}, "basic walker") do screen = .BASIC_WALKER
	if rl.GuiLabelButton(rl.Rectangle{30, 120, 100, 40}, "flow field") do screen = .FLOW_FIELD

	rl.EndDrawing()
	return .NONE
}
