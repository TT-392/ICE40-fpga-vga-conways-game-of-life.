vga.bin: vga.txt
	icepack vga.txt vga.bin

vga.txt: vga.pcf vga.blif
	arachne-pnr -d 1k -p vga.pcf -o vga.txt vga.blif

vga.blif: vga.v
	yosys -p "read_verilog vga.v; synth_ice40 -blif vga.blif"

upload: vga.bin
	iceprog vga.bin

clean:
	rm -rf *.blif *.bin *.txt

check:
	yosys -p "read_verilog vga.v; synth_ice40 -blif vga.blif"
