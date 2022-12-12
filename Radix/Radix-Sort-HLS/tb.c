//
// Created by Hevos on 23.11.2022.
//

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "radix.h"

int main(){

	printf("Ooogabooga");

	char in[] = "computer";
    uint8_t out;

    printf("\n Output: ");

    radix(in, &out);
    printf("%d", out);
}
