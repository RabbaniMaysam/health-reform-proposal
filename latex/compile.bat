@echo off
cd /d f:\GDrive\16_pharma_reform_proposal\latex
"C:\Users\rabba\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe" -interaction=nonstopmode main.tex
echo First pass complete
"C:\Users\rabba\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe" -interaction=nonstopmode main.tex
echo Second pass complete
echo Compilation done
