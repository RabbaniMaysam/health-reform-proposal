#!/usr/bin/env python3
import subprocess
import os
import sys

os.chdir(r'f:\GDrive\16_pharma_reform_proposal\latex')
pdflatex = r'C:\Users\rabba\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe'

print("=== First pass ===")
result1 = subprocess.run([pdflatex, '-interaction=nonstopmode', 'main.tex'])
print(f"Return code: {result1.returncode}\n")

print("=== Second pass ===")
result2 = subprocess.run([pdflatex, '-interaction=nonstopmode', 'main.tex'])
print(f"Return code: {result2.returncode}\n")

if result1.returncode == 0 and result2.returncode == 0:
    print("✓ Compilation successful!")
    sys.exit(0)
else:
    print("✗ Compilation failed")
    sys.exit(1)
