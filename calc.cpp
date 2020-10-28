// calc.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <math.h>
#include <conio.h>
#include <locale.h>
#include <cassert>
#include "Header.h"

int main()
{
	setlocale(LC_ALL, "Russian");
	int num;
	float f = 3.5; // коэффициент крепости
	float u = 65; // угол внутреннего трения
	float B, h, H;
	std::cout << "Первичный вид расчетов представлен для горной породы Мергель (f = 3,5, u = 65)" << std::endl;
	std::cout << "Выберите первичные данные:" << std::endl;
	std::cout << "1. H = 20м, h = 9м, B = 10м" << std::endl;
	std::cout << "2. H = 0,5м, h = 9м, B = 10м" << std::endl;
	std::cin >> num;
	switch (num)
	{
	case 1:
		B = 10;
		h = 9;
		H = 20;
		if (calc(B, h, u, f, H))
			std::cout << "Свод обрушения" << std::endl;
		else
			std::cout << "Столб обрушения" << std::endl;
		test(B, h, u, f, H, num);
		break;
	case 2:
		B = 10;
		h = 9;
		H = 0.5;
		if (calc(B, h, u, f, H))
			std::cout << "Свод обрушения" << std::endl;
		else
			std::cout << "Столб обрушения" << std::endl;
		test(B, h, u, f, H, num);
		break;
	}
	_getch();
}
