default: run

build:
    odin build . -collection:nature=.

run: build
    odin run . -collection:nature=.
