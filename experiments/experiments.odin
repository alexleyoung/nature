package experiments

Screen :: struct {
  // optional
	init:   proc(back: proc()),
  // required
	update: proc(back: proc()),
}
