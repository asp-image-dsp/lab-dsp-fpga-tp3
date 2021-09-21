::-------------------------------------------------------------------
:: file           asm.bat
:: version        v1.1.2
:: author         Lucas A. Kammann
:: date           20210830
:: description    Run the assembly compiler for Motorola's DSP 56300
::-------------------------------------------------------------------

:: Move to the build/ directory to save all outputs
@echo off
cd ..
mkdir build
@echo on

:: Execute the assembly compiler
cd src
"..\compiler\asm56300.exe" -b -l %1.asm
move *.cln ..\build
move *.lst ..\build
cd ..
cd tools

:: Return to the corresponding folder
@echo off
cd ..
cd tools
@echo on