package experiments

Screen :: struct {
	// optional
	init:   proc(),
	// optional, run on switch away
	deinit: proc(),
	// required; returns the navigation it wants
	update: proc() -> Transition,
}

Transition :: enum {
	NONE,
	BACK,
}
