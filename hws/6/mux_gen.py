# shift left logical
if 0:
    for i in range(32):
        print("mux32 #(.N(1)) MUX_{} (".format(i))
        for j in range(32):
            if j+i < 32:
                print(".in{:02d}(in[{:02d}]), ".format(j, 32 - (j+i+1)), end='')
            else:
                print(".in{:02d}(1'd0), ".format(j), end='')
        print(".select(shamt), .out(out[N-{}])".format(i+1))
            
        # print(", ".join([f".in{j:02d}(in{j+i if j+i < 32 else 0:02d})" for j in range(32)]), ",")
        print(");")

# shift right logical
if 0:
    for i in range(32):
        # print('I', i)
        print("mux32 #(.N(1)) MUX_{} (".format(i))
        counter = 31 - i
        for j in reversed(range(32)):
            # print('J', j)
            if counter <= 31:
                # print(counter, 31- i )
                print(".in{:02d}(in[{:02d}]), ".format(31 - j, counter), end='')
                counter += 1
            else:
                print(".in{:02d}(1'd0), ".format(31 - j), end='')
        print(".select(shamt), .out(out[N-{}])".format(i+1))
            
        # print(", ".join([f".in{j:02d}(in{j+i if j+i < 32 else 0:02d})" for j in range(32)]), ",")
        print(");")

# shift right arithmetic
if 0:
    for i in range(32):
        # print('I', i)
        print("mux32 #(.N(1)) MUX_{} (".format(i))
        counter = 31 - i
        for j in reversed(range(32)):
            # print('J', j)
            if counter <= 31:
                # print(counter, 31- i )
                print(".in{:02d}(in[{:02d}]), ".format(31 - j, counter), end='')
                counter += 1
            else:
                print(".in{:02d}(in[31]), ".format(31 - j), end='')
        print(".select(shamt), .out(out[N-{}])".format(i+1))
            
        # print(", ".join([f".in{j:02d}(in{j+i if j+i < 32 else 0:02d})" for j in range(32)]), ",")
        print(");")

if 0:
    for i in range(31):
        print("register #(.N(1)) REG_{} (".format(i+1))
        print(".clk(clk), .ena(ena_select[{}]), .rst(0), .d(wr_data), .q(x{:02d})".format(i+1, i+1))
        print(");")
