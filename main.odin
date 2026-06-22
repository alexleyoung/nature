package main

import rl "vendor:raylib"

import "nature:experiments"
import bw "nature:experiments/basic_walker"
import ff "nature:experiments/flow_field"
import nwalk "nature:experiments/noise_walker"
import nwave "nature:experiments/noise_wave"
import basicfollowmouse "nature:experiments/basic_follow_mouse"

WIDTH :: 640
HEIGHT :: 640

SCREEN :: enum {
	MENU,
	BASIC_WALKER,
	NOISE_WALKER,
	NOISE_WAVE,
	FLOW_FIELD,
	BASIC_FOLLOW_MOUSE,
}

screen := SCREEN.MENU

screens := [SCREEN]experiments.Screen {
	.MENU = {update = main_menu_render},
	.BASIC_WALKER = bw.Screen,
	.NOISE_WALKER = nwalk.Screen,
	.NOISE_WAVE = nwave.Screen,
	.FLOW_FIELD = ff.Screen,
	.BASIC_FOLLOW_MOUSE = basicfollowmouse.Screen,
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
	if rl.GuiLabelButton(rl.Rectangle{30, 120, 100, 40}, "noise walker") do screen = .NOISE_WALKER
	if rl.GuiLabelButton(rl.Rectangle{30, 160, 100, 40}, "noise wave") do screen = .NOISE_WAVE

	if rl.GuiLabelButton(rl.Rectangle{30, 200, 100, 40}, "basic follow mouse") do screen = .BASIC_FOLLOW_MOUSE
	rl.EndDrawing()
	return .NONE
}
