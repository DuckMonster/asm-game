#include <stdio.h>
#include <stdarg.h>
#include <windows.h>
#include "types.h"

HWND wnd_hndl;
bool window_open = false;
HBITMAP bmp_hndl;

HDC wnd_dc;
HDC bmp_dc;

u32 wnd_width = 0;
u32 wnd_height = 0;

u32 screen_width = 100;
u32 screen_height = 80;
u8* screen_data;

LARGE_INTEGER time_frequency;
LARGE_INTEGER time_last;
float frame_delta = 0.f;

float f_multi(float a, float b)
{
	return a + b;
}

LRESULT CALLBACK wnd_proc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	switch(msg)
	{
		case WM_SIZE:
		{
			typedef struct
			{
				u16 width;
				u16 height;
			} Win_Size;

			Win_Size* size = (Win_Size*)(&lParam);
			wnd_width = size->width;
			wnd_height = size->height;

			break;
		}
		case WM_DESTROY:
		{
			window_open = false;
			break;
		}
	}

	return DefWindowProc(hWnd, msg, wParam, lParam);
}

void g_print(const char* msg, ...)
{
	va_list vl;
	va_start(vl, msg);
	vprintf(msg, vl);
	va_end(vl);
}

void g_init(const char* title, u32 width, u32 height)
{
	// Register class
	WNDCLASSEX wc;
	ZeroMemory(&wc, sizeof(wc));

	HINSTANCE instance = GetModuleHandle(NULL);

	wc.cbSize = sizeof(wc);
	wc.style = CS_OWNDC;
	wc.hbrBackground = (HBRUSH)(COLOR_BACKGROUND);
	wc.hInstance = instance;
	wc.lpszClassName = "MyClass";
	wc.lpfnWndProc = wnd_proc;

	RegisterClassEx(&wc);

	// Open windows!
	wnd_width = width;
	wnd_height = height;

	wnd_hndl = CreateWindow(
		wc.lpszClassName,
		title,
		WS_OVERLAPPEDWINDOW | WS_VISIBLE,
		100, 100, width, height,
		0, 0,
		instance,
		0
	);

	// Create the bitmap yo
	wnd_dc = GetDC(wnd_hndl);
	bmp_dc = CreateCompatibleDC(wnd_dc);
	bmp_hndl = CreateCompatibleBitmap(wnd_dc, screen_width, screen_height);
	SelectObject(bmp_dc, bmp_hndl);

	screen_data = (u8*)malloc(screen_width * screen_height * 4);
	ZeroMemory(screen_data, screen_width * screen_height * 4);

	window_open = true;

	// Init time
	QueryPerformanceFrequency(&time_frequency);
	QueryPerformanceCounter(&time_last);
}

u32 frame_number = 0;

void g_update()
{
	frame_number++;

	// Set bitmap data
	BITMAPINFO info;
	memset(&info, 0, sizeof(info));

	info.bmiHeader.biSize = sizeof(info.bmiHeader);
	info.bmiHeader.biWidth = screen_width;
	info.bmiHeader.biHeight = screen_height;
	info.bmiHeader.biPlanes = 1;
	info.bmiHeader.biBitCount = 32;

	info.bmiHeader.biCompression = BI_RGB;
	info.bmiHeader.biSizeImage = 0;
	SetDIBits(wnd_dc, bmp_hndl, 0, screen_height, screen_data, &info, DIB_RGB_COLORS);

	// Blit to screen
	StretchBlt(wnd_dc, 0, 0, wnd_width, wnd_height, bmp_dc, 0, 0, screen_width, screen_height, SRCCOPY);

	// Dispatch all messages
	MSG msg;
	if (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	Sleep(16);

	// Update delta time
	LARGE_INTEGER time_now;
	QueryPerformanceCounter(&time_now);
	frame_delta = (float)(time_now.QuadPart - time_last.QuadPart) / time_frequency.QuadPart;

	time_last = time_now;
}

bool g_isopen()
{
	return window_open;
}

float g_framedelta()
{
	return frame_delta;
}