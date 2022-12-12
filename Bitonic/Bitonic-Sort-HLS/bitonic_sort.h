#ifndef BITONIC_SORT_H
#define BITONIC_SORT_H

#include "ap_int.h"

#define DATA_SIZE 256
#define DATA_WIDTH 8

void bitonic_sort(ap_int<DATA_WIDTH> data_in[DATA_SIZE],
                  ap_int<DATA_WIDTH> data_out[DATA_SIZE]);

void sort_list(ap_int<DATA_WIDTH> arr[DATA_SIZE]);

void order(ap_int<DATA_WIDTH> &a,
           ap_int<DATA_WIDTH> &b,
           bool sort_up);

void swap(ap_int<DATA_WIDTH> &a,
          ap_int<DATA_WIDTH> &b);

#endif
