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