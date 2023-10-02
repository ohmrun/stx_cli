unit:
    clear && hb build unit
test-interp:
    @clear && hb build test/interp
watch-test-interp:
    watchexec just test-interp
run:
    clear && hb build run