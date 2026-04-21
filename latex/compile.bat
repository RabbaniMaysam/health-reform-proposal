@echo off
cd /d f:\GDriveMay\Maysam\01_research\16_pharma_reform_proposal
"C:\Program Files\R\R-4.5.2\bin\Rscript.exe" code\generate_faq_numbers.R
echo FAQ numbers regenerated
cd latex
"C:\Users\rabba\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe" -interaction=nonstopmode main.tex
echo First pass complete
"C:\Users\rabba\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe" -interaction=nonstopmode main.tex
echo Second pass complete
echo Compilation done
