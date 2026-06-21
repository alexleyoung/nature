package noise_walker

import "core:math/noise"
import "core:math/rand"

import exp "nature:experiments"
import rl "vendor:raylib"

SPEED :: 0.001
SCALE :: 1.5
STROKE_WIDTH :: 3
INSET :: 50

Walker :: struct {
	pos, prev: [2]f32,
}

canvas: rl.RenderTexture2D
walker: Walker
width, height: i32
noise_seed: i64

t: f64 = 0
xoff: f64
yoff: f64
roff: f64
goff: f64
boff: f64

Screen :: exp.Screen {
	init   = init,
	deinit = deinit,
	update = update,
}

init :: proc() {
	width = rl.GetScreenWidth()
	height = rl.GetScreenHeight()
	walker = Walker{{f32(width) / 2, f32(height) / 2}, {0, 0}}
	noise_seed = rand.int63()

	xoff = rand.float64()
	yoff = rand.float64()
	roff = rand.float64()
	goff = rand.float64()
	boff = rand.float64()

	canvas = rl.LoadRenderTexture(width, height)
	rl.BeginTextureMode(canvas)
	rl.ClearBackground(rl.RAYWHITE)
	rl.EndTextureMode()
}

deinit :: proc() {
	rl.UnloadRenderTexture(canvas)
}

update :: proc() -> exp.Transition {
	t += SPEED

	walker.prev = walker.pos
	walker.pos.x += f32(noise.noise_2d(noise_seed, {t, xoff})) * SCALE
	walker.pos.y += f32(noise.noise_2d(noise_seed, {t, yoff})) * SCALE
	walker.pos.x = clamp(walker.pos.x, 0 + INSET, f32(width) - INSET)
	walker.pos.y = clamp(walker.pos.y, 0 + INSET, f32(height) - INSET)

	color := rl.Color {
		u8((noise.noise_2d(noise_seed, {t, roff}) + 1) * 128),
		u8((noise.noise_2d(noise_seed, {t, goff}) + 1) * 128),
		u8((noise.noise_2d(noise_seed, {t, boff}) + 1) * 128),
		255,
	}

	rl.BeginTextureMode(canvas)
	rl.DrawLineEx(walker.prev, walker.pos, STROKE_WIDTH, color)
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
