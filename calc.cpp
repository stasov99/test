// calc.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <math.h>
#include <conio.h>
#include <locale.h>
#include <cassert>

int calc(float B, float h, float u, float f, float H)
{
	float h1 = (B + 2 * h * tan((45 - u / 2)/57.3))/2/f;
	if (h1 < 2 * H)
		return 1;
	else
		return 0;
}

int main()
{
	setlocale(LC_ALL, "Russian");
	int num;
	float f = 3.5; // ����������� ��������
	float u = 65; // ���� ����������� ������
	float B, h, H;
	std::cout << "��������� ��� �������� ����������� ��� ������ ������ ������� (f = 3,5, u = 65)" << std::endl;
	std::cout << "�������� ��������� ������:" << std::endl;
	std::cout << "1. H = 20�, h = 9�, B = 10�" << std::endl;
	std::cout << "2. H = 0,5�, h = 9�, B = 10�" << std::endl;
	std::cin >> num;
	switch (num)
	{
	case 1:
		B = 10;
		h = 9;
		H = 20;
		if (calc(B, h, u, f, H))
			std::cout << "���� ���������" << std::endl;
		else
			std::cout << "����� ���������" << std::endl;
		break;
	case 2:
		B = 10;
		h = 9;
		H = 0.5;
		if (calc(B, h, u, f, H))
			std::cout << "���� ���������" << std::endl;
		else
			std::cout << "����� ���������" << std::endl;
		break;
	}
	test(B, h, u, f, H);
	_getch();
}
