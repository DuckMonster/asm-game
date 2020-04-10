@echo off

rem Setup VS vars
pushd "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build"
call vcvars64.bat
popd

setlocal EnableDelayedExpansion
set /a has_error=0

rem C COMPILING
echo -- Building C --
set FLAGS=/c /analyze- /W3 /Gm- /Od /WX- /nologo

pushd src
for %%f in (*.c) do (
	rem Build it
	cl !FLAGS! /nologo %%f /Fo..\obj\
	if ERRORLEVEL 1 (
		set /a has_error=1
		echo %%f failed
	)
)
popd

echo.

rem ASM COMPILING
echo -- Building ASM --

pushd src
for %%f in (*.asm) do (
	echo %%f

	rem Get the out file pat
	set out_path=%%f
	set out_path=..\obj\!out_path:.asm=.obj!

	rem Build it
	nasm -f win64 %%f -o !out_path!
	if ERRORLEVEL 1 (
		echo %%f failed
		set /a has_error=1
	)
)
popd

echo.

rem Don't continue if we have errors
if !has_error!==1 goto fail

rem LINKING
set LIBS=/defaultlib:kernel32.lib /defaultlib:user32.lib /defaultlib:ucrt.lib /defaultlib:vcruntime.lib /defaultlib:msvcrt.lib /defaultlib:gdi32.lib
set FLAGS=/nologo /subsystem:console /debug:fastlink

echo -- Link --
set link_files=
pushd obj
for %%f in (*.obj) do (
	set link_files=!link_files! %%f
)

link !link_files! !LIBS! !FLAGS! /out:..\bin\game.exe /entry:main
popd

echo.

echo -- Build successful! --
exit 0

:fail
echo -- Build failed --
exit 1