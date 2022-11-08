#!/usr/bin/env python

import numpy as np

SECONDS_IN_A_DAY = 24*60*60*1.0
SECONDS_IN_A_YEAR = 365*SECONDS_IN_A_DAY

def probability_of_failure(
  f_c = 1e6,
  f_d = 10.0,
  t_setup = 200e-12,
  T_0 = 225e-12,
  tau = 175e-12
):
  T_c = 1.0/f_c
  return f_d*f_c*T_0*np.exp(-(T_c - t_setup)/tau)

if __name__ == "__main__":
    N = 24.0
    freq_list = [3.18 * 10**8, 3.16 * 10**8, 3.14 * 10**8, 3.12 * 10**8, 3.1 * 10**8]
    for f_c in freq_list:  
        p_f_individual = probability_of_failure(f_c = f_c)
        p_f_system = N*p_f_individual
        MTBF_individual = 1/p_f_individual
        MTBF_system = 1/p_f_system

        print(f"f_c = {f_c:e} Hz, p(f) = {p_f_individual:e}, MTBF_system = {MTBF_individual/SECONDS_IN_A_YEAR:8.1f} years")

    # f_c = 3.5 * 10**8
    # p_f_individual = probability_of_failure(f_c = f_c)
    # MTBF_individual = 1/p_f_individual
    
    # print(f"f_c = {f_c:e} Hz, p(f) = {p_f_individual:e}, MTBF_system = {MTBF_individual/SECONDS_IN_A_YEAR:8.1f} years")
