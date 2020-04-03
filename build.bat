@echo off

rem Setup VS vars
pushd "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64"
call vcvars64.bat
popd

setlocal EnableDelayedExpansion
set /a has_error=0

rem C COMPILING
echo -- Building C --
set FLAGS=/c /JMC /permissive- /GS /analyze- /W3 /Zc:wchar_t /ZI /Gm- /Od /sdl /Zc:inline /fp:precise /D "_MBCS" /errorReport:prompt /WX- /Zc:forScope /RTC1 /Gd /Oy- /MDd /FC /EHsc /nologo /diagnostics:classic

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
set FLAGS=/MANIFEST /NXCOMPAT /DYNAMICBASE "kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" "odbc32.lib" "odbccp32.lib" "ucrtd.lib" "vcruntimed.lib" "msvcrtd.lib" /DEBUG:FASTLINK /MACHINE:X86 /INCREMENTAL /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /ERRORREPORT:PROMPT /NOLOGO /TLBID:1

echo -- Link --
set link_files=
pushd obj
for %%f in (*.obj) do (
	set link_files=!link_files! %%f
)

link !link_files! !FLAGS! /nologo /out:..\bin\game.exe /entry:main /subsystem:console /machine:x64
popd

echo.

echo -- Build successful! --
exit 0

:fail
echo -- Build failed --
exit 1