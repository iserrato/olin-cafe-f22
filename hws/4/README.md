# Homework 4
The written portion is available [here](https://docs.google.com/document/d/1XybXmTD5-NTJ1gfLq3tYb-wUUDJGZS8xgO912DLf50Q/edit?usp=sharing)

Add a pdf of your written answers to this folder, then use `make clean` then `make submission` to submit!

## Implementation
### 32-bit adder
In order to create the 32-bit adder, I created a 1-bit adder that takes in a, b, and a carry in and produces a sum and a carry out. I cascaded the 1-bit adders to create a ripple carry adder, with the total number of addders being a changeable parameter. While this approach is slow, it does successfully create a 32-bit adder.

### 32-bit mux
I created smaller modules to build a 32-bit mux. I started with a 2-bit mux, then used three of those to create a four-bit mux, then used five of those to create a 16-bit mux, then finally used two 16-bit muxes and a 2-bit mux to create a 32-bit mux. 

## Testing
To create the test for the 32-bit mux, I first instantiated a 32-bit mux, and then assigned different decimal values for each of its inputs. Then, I incremented the select signal with a delay of 10ns. The mux recorded the output for each select value, and when complete, the testbench output a wave form that I was able to examine in GTKWave. The waveform appeared as expected.

To run the tests, navigate to the directory that contains the test files and run `make test_mux32` to generate the waveform and then `gtkwave mux32.fst` to view the waveform. All prerequisites must be installed.