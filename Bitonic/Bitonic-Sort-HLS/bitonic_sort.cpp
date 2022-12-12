#include "bitonic_sort.h"

void bitonic_sort(ap_int<DATA_WIDTH> data_in[DATA_SIZE],
                  ap_int<DATA_WIDTH> data_out[DATA_SIZE])
{
    #pragma HLS INTERFACE mode=s_axilite port=data_in
    #pragma HLS INTERFACE mode=s_axilite port=data_out
    #pragma HLS INTERFACE mode=s_axilite port=bitonic_sort

	ap_int<DATA_WIDTH> arr[DATA_SIZE];

    for(int i = 0; i < DATA_SIZE; i++)
    {
    	arr[i] = data_in[i];
    }

	sort_list(arr);

	for(int i = 0; i < DATA_SIZE; i++)
	{
		data_out[i] = arr[i];
	}
}

void sort_list(ap_int<DATA_WIDTH> arr[DATA_SIZE])
{
    int i,j,k;
    for (k = 2; k <= DATA_SIZE; k *= 2)
    {
        for (j = k / 2; j > 0; j /= 2)
        {
            for (i = 0; i < DATA_SIZE; i++)
            {
                int l = i ^ j;
                if (l > i) {
                	order(arr[i], arr[l], (i & k) != 0);
                }
            }
        }
    }
}


void order(ap_int<DATA_WIDTH> &a,
           ap_int<DATA_WIDTH> &b,
           bool sort_up)
{
    if (sort_up != (a > b))
    {
		swap(a, b);
	}
}

void swap(ap_int<DATA_WIDTH> &a,
          ap_int<DATA_WIDTH> &b)
{
    ap_int<DATA_WIDTH> temp = a;
    a = b;
    b = temp;
}
