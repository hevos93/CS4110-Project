#include "bitonic_sort.h"
#include <stdio.h>

int main()
{
	char test_data[] = "931d62bfe58a4c7\0";
	ap_int<DATA_WIDTH> input[DATA_SIZE];
	ap_int<DATA_WIDTH> output[DATA_SIZE];

	for(int i = 0; i < DATA_SIZE; i++)
	{
		input[i] = test_data[i];
	}

	printf("%s\n", test_data);

	bitonic_sort(input, output);

	for(int i = 0; i < DATA_SIZE; i++)
	{
		printf("%c", input[i]);
	}
	printf("\n");

	for(int i = 0; i < DATA_SIZE; i++)
	{
		printf("%c", output[i]);
	}
	printf("\n");

	return 0;
}
