ori  t0, x0, 8 # led0
slli t0, t0, 4 
ori  t0, t0, 4 # led1
slli t0, t0, 4
ori  t0, t0, 127 # half red
slli t0, t0, 8
ori  t0, t0, 0 # no green
slli t0, t0, 8
ori  t0, t0, 255 # full blue