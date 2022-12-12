//
// Created by Hevos on 22.11.2022.
//

#ifndef RADIX_RADIX_H
#define RADIX_RADIX_H

#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define DATA_SIZE 8
#define DATA_WIDTH 8

void radix(const char input[DATA_SIZE], uint8_t output[DATA_SIZE]);

#endif //RADIX_RADIX_H
