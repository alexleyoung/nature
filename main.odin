package main

import rl "vendor:raylib"

WIDTH :: 640
HEIGHT :: 640

SCREEN :: enum {
	MENU,
	BASIC_WALKER,
}

main :: proc() {
	rl.InitWindow(WIDTH, HEIGHT, "nature")

	rl.GuiSetStyle(.DEFAULT, i32(rl.GuiDefaultProperty.TEXT_SIZE), 32)

	screen := SCREEN.MENU

	main_loop: for !rl.WindowShouldClose() {
		switch screen {
		case .MENU:
			rl.BeginDrawing()
			rl.ClearBackground(rl.RAYWHITE)
			rl.DrawText("nature", 20, 20, 48, rl.BLACK)
			if rl.GuiLabelButton(rl.Rectangle{30, 80, 100, 40}, "basic walker") do screen = .BASIC_WALKER
			rl.EndDrawing()

		case .BASIC_WALKER:
			rl.BeginDrawing()
			rl.ClearBackground(rl.RAYWHITE)
			if rl.GuiLabelButton(rl.Rectangle{30, 20, 80, 40}, "back") do screen = .MENU
			rl.EndDrawing()
		}
	}
}
