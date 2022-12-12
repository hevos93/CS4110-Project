#include "merge_sort.h"

/* UTILITY FUNCTIONS */
/* Function to print an array */
void printArray(uint8_t A[], uint8_t size)
{
	int i;
	for (i = 0; i < size; i++)
		printf("%c ", A[i]);
	printf("\n");
}

/* Driver code */
int main()
{
	char test_data[] = "computer";
	uint8_t arr_size = DATA_SIZE;
	uint8_t output_arr[arr_size];
	uint8_t input_arr[arr_size];

	for (uint8_t i = 0; i < arr_size; i++)
	{
		input_arr[i] = test_data[i];
	}

	printf("Given array is \n");
	printArray(input_arr, arr_size);

	merge_sort(input_arr, output_arr);

	printf("\nSorted array is \n");
	printArray(output_arr, arr_size);
	return 0;
}
