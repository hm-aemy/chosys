
.PHONY: test1 test2 clean

default: ALL

ALL: test1 test2

test1/out:
	mkdir -p test1/out

test1/out/input_rtlil.mlir: test1/input.mlir test1/out
	circt-opt --convert-hw-to-rtlil $< > $@

test1/out/cpu2.v: test1/out test1/out/input_rtlil.mlir test1/script.ys
	cd test1 && \
	yosys -m ../../build/librtlil-emit.so script.ys

test1/out/sim: test1/out/cpu2.v test1/tb.v
	iverilog -o test1/out/sim test1/out/cpu2.v test1/tb.v

test1: test1/out/sim
	vvp test1/out/sim tb

test2/out:
	mkdir -p test2/out

test2/out/GCD_rtlil.mlir: test2/GCD.mlir test2/out
	circt-opt --convert-hw-to-rtlil $< > $@

test2/out/cpu2.v: test2/out test2/out/GCD_rtlil.mlir test2/script.ys
	cd test2 && \
	yosys -m ../../build/librtlil-emit.so script.ys

test2/out/sim: test2/out/cpu2.v test2/tb.v
	iverilog -o $@ $^

test2: test2/out/sim
	vvp test2/out/sim tb

clean:
	rm -rf test1/out test2/out