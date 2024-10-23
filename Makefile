name=gcd_x8086
target=$(name).bin
run: $(target)
	qemu-system-x86_64 -drive format=raw,file=$(target)
# No graphics (qui: CTRL-A X)
# qemu-system-x86_64 -curses -drive format=raw,file=$(target)