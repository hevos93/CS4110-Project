//Taken from https://www.programiz.com/dsa/radix-sort
// Radix Sort in C Programming

#include "radix.h"

// Function to get the largest element from an array
int getMax(int array[], int n) {
    int max = array[0];
    for (int getMax_counter = 1; getMax_counter < n; getMax_counter++)
        if (array[getMax_counter] > max)
            max = array[getMax_counter];
    return max;
}

// Using counting sort to sort the elements in the basis of significant places
void countingSort(int array[], int size, int place) {
    int output[size + 1];
    int max = (array[0] / place) % 10;

    for (int countingSort_counter1 = 1; countingSort_counter1 < size; countingSort_counter1++) {
        if (((array[countingSort_counter1] / place) % 10) > max)
            max = array[countingSort_counter1];
    }
    int count[6];

    for (int countingSort_counter2 = 0; countingSort_counter2 < max; ++countingSort_counter2)
        count[countingSort_counter2] = 0;

    // Calculate count of elements
    for (int countingSort_counter3 = 0; countingSort_counter3 < size; countingSort_counter3++)
        count[(array[countingSort_counter3] / place) % 10]++;

    // Calculate cumulative count
    for (int countingSort_counter4 = 1; countingSort_counter4 < 10; countingSort_counter4++)
        count[countingSort_counter4] += count[countingSort_counter4 - 1];

    // Place the elements in sorted order
    for (int countingSort_counter5 = size - 1; countingSort_counter5 >= 0; countingSort_counter5--) {
        output[count[(array[countingSort_counter5] / place) % 10] - 1] = array[countingSort_counter5];
        count[(array[countingSort_counter5] / place) % 10]--;
    }

    for (int countingSort_counter6 = 0; countingSort_counter6 < size; countingSort_counter6++)
        array[countingSort_counter6] = output[countingSort_counter6];
}

// Main function to implement radix sort
void radixsort(int array[], int size) {
    // Get maximum element
    int max = getMax(array, size);

    // Apply counting sort to sort elements based on place value.
    for (int place = 1; max / place > 0; place *= 10)
        countingSort(array, size, place);
}

void radix(const char input[], uint8_t* output){
    #pragma HLS INTERFACE mode=s_axilite port=input
    #pragma HLS INTERFACE mode=s_axilite port=output
    #pragma HLS INTERFACE mode=s_axilite port=radix

	uint8_t size_str = sizeof(input);
    uint8_t arr_counter = 0;
    uint8_t counter = 0;
    char str[size_str];
    uint8_t array[size_str];

    while (counter<size_str){
        str[counter] = input[counter];
        printf("%c\t%c\n", str[counter], input[counter]);
        if(str[counter]==','){
            counter++;
        } else{
            int typecast = (int)(str[counter]);
            array[arr_counter]=typecast;
            printf("%c\n", array[arr_counter]);
            arr_counter++;
            counter++;
        }
    }
    //Use an existing array, this needs to be changed
    //int array[] = input;

    //Get the size of array
    uint8_t n = sizeof(array) / sizeof(array[0]);

    //Sort the array
    radixsort(array, n);
    *output = array;
}
