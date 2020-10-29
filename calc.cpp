// calc.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <math.h>
#include <locale.h>
#include <cassert>
#include "Header.h"

int main()
{
	setlocale(LC_ALL, "Russian");
	int num;
	float f = 3.5; // êîýôôèöèåíò êðåïîñòè
	float u = 65; // óãîë âíóòðåííåãî òðåíèÿ
	float B, h, H;
	std::cout << "Ïåðâè÷íûé âèä ðàñ÷åòîâ ïðåäñòàâëåí äëÿ ãîðíîé ïîðîäû Ìåðãåëü (f = 3,5, u = 65)" << std::endl;
	std::cout << "Âûáåðèòå ïåðâè÷íûå äàííûå:" << std::endl;
	std::cout << "1. H = 20ì, h = 9ì, B = 10ì" << std::endl;
	std::cout << "2. H = 0,5ì, h = 9ì, B = 10ì" << std::endl;
	std::cin >> num;
	switch (num)
	{
	case 1:
		B = 10;
		h = 9;
		H = 20;
		if (calc(B, h, u, f, H))
			std::cout << "Ñâîä îáðóøåíèÿ" << std::endl;
		else
			std::cout << "Ñòîëá îáðóøåíèÿ" << std::endl;
		test(B, h, u, f, H, num);
		break;
	case 2:
		B = 10;
		h = 9;
		H = 0.5;
		if (calc(B, h, u, f, H))
			std::cout << "Ñâîä îáðóøåíèÿ" << std::endl;
		else
			std::cout << "Ñòîëá îáðóøåíèÿ" << std::endl;
		test(B, h, u, f, H, num);
		break;
	}
}
