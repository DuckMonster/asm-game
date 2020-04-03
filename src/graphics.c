#include <stdio.h>
#include <stdarg.h>
#include <windows.h>

extern void asm_main();

LRESULT CALLBACK wnd_proc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	return DefWindowProc(hWnd, msg, wParam, lParam);
}

void g_init(const char* msg)
{
	system("pause");
	//puts(msg);

/*
	WNDCLASSEX wc;
	ZeroMemory(&wc, sizeof(wc));

	HINSTANCE instance = GetModuleHandle(NULL);

	wc.cbSize = sizeof(wc);
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.hbrBackground = (HBRUSH)(COLOR_BACKGROUND);
	wc.hInstance = instance;
	wc.lpszClassName = "MyClass";
	wc.lpfnWndProc = wnd_proc;

	RegisterClassEx(&wc);
*/

/*
	va_list vl;
	va_start(vl, msg);
	vprintf(msg, vl);
	va_end(vl);
*/
}

int main()
{
	g_init("Hello, World!");
	asm_main();
}