unit:
    clear && hx build unit
test-interp:
    @clear && hx build test/interp
watch-test-interp:
    watchexec just test-interp
run:
    clear && hx build run