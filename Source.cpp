#include <math.h>
#include <cassert>
#include <iostream>
#include "Header.h"

int calc(float B, float h, float u, float f, float H)
{
	float h1 = (B + 2 * h * tan((45 - u / 2) / 57.3)) / 2 / f;
	if (h1 <= 2 * H)
		return 1;
	else
		return 0;
}

void test(float B, float h, float u, float f, float H, int num)
{
	float a = (B + 2 * h * tan((45 - u / 2) / 57.3)) / 2 / f;
	if (num == 1)
		assert(a <= 2 * H);
	else assert(a > 2 * H);
	std::cout << "OK" << std::endl;
}