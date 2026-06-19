package experiments

Screen :: struct {
	// optional
	init:   proc(),
	// optional, run on switch away
	deinit: proc(),
	// required
	update: proc(back: proc()),
}
