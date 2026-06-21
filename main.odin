package main

import rl "vendor:raylib"

import "nature:experiments"
import bw "nature:experiments/basic_walker"
import nw "nature:experiments/noise_wave"
import nw2d "nature:experiments/noise_wave_2d"
import ff "nature:experiments/flow_field"

WIDTH :: 640
HEIGHT :: 640

SCREEN :: enum {
	MENU,
	BASIC_WALKER,
	NOISE_WAVE,
	NOISE_WAVE_2D,
	FLOW_FIELD,
}

screen := SCREEN.MENU

screens := [SCREEN]experiments.Screen {
	.MENU         = {update = main_menu_render},
	.BASIC_WALKER = bw.Screen,
	.NOISE_WAVE   = nw.Screen,
	.NOISE_WAVE_2D = nw2d.Screen,
	.FLOW_FIELD   = ff.Screen,
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

main_menu_render :: proc() -> experiments.Transition {
	rl.BeginDrawing()
	rl.ClearBackground(rl.RAYWHITE)

	rl.DrawText("nature", 20, 20, 48, rl.BLACK)
	if rl.GuiLabelButton(rl.Rectangle{30, 80, 100, 40}, "basic walker") do screen = .BASIC_WALKER
	if rl.GuiLabelButton(rl.Rectangle{30, 120, 100, 40}, "noise wave") do screen = .NOISE_WAVE
	if rl.GuiLabelButton(rl.Rectangle{30, 160, 100, 40}, "noise wave 2d") do screen = .NOISE_WAVE_2D

	rl.EndDrawing()
	return .NONE
}
