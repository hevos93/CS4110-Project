/* C program for Merge Sort */
#include "merge_sort.h"
#include <stdlib.h>
#include <assert.h>

void merge_sort(uint8_t input[DATA_SIZE], uint8_t output[DATA_SIZE])
{
#pragma HLS INTERFACE mode=s_axilite port=merge_sort
#pragma HLS INTERFACE mode=s_axilite port=input
#pragma HLS INTERFACE mode=s_axilite port=output
	uint8_t temp[DATA_SIZE];

//	for (uint8_t a = 0; a < DATA_SIZE; a++)
//	{
//		arr[a] = input[a];
//	}

	for (uint8_t width = 1; width < DATA_SIZE; width = 2*width)
	{
		uint8_t f1 = 0;
		uint8_t f2 = width;
		uint8_t i2 = width;
		uint8_t i3 = 2*width;

		if(i2 >= DATA_SIZE) i2 = DATA_SIZE;
		if(i3 >= DATA_SIZE) i3 = DATA_SIZE;

		for (uint8_t i = 0; i < DATA_SIZE; i++)
		{
//			#pragma HLS pipeline II=1
			uint8_t t1 = input[f1];
			uint8_t t2 = (f2 == i3) ? 0 : input[f2];

			if (f2 == i3 || (f1 < i2 && t1 <= t2))
			{
				temp[i] = t1;
				f1++;
			}
			else
			{
				assert(f2 < i3);
				temp[i] = t2;
				f2++;
			}

			if (f1 == i2 && f2 == i3)
			{
				f1 = i3;
				i2 += 2*width;
				i3 += 2*width;

				if (i2 >= DATA_SIZE) i2 = DATA_SIZE;
				if (i3 >= DATA_SIZE) i3 = DATA_SIZE;
				f2 = i2;
			}
		}

		for (uint8_t j = 0; j < DATA_SIZE; j++)
		{
//			#pragma HLS pipeline II=1
			input[j] = temp[j];
		}
	}

	for (uint8_t x = 0; x < DATA_SIZE; x++)
	{
		output[x] = input[x];
	}
}
