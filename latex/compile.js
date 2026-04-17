const { execSync } = require('child_process');
const path = require('path');

const latexDir = r'f:\GDrive\16_pharma_reform_proposal\latex';
const pdflatex = r'C:\Users\rabba\AppData\Local\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe';

try {
    console.log("=== First pass ===");
    execSync(`"${pdflatex}" -interaction=nonstopmode main.tex`, { 
        cwd: latexDir,
        stdio: 'inherit'
    });
    
    console.log("\n=== Second pass ===");
    execSync(`"${pdflatex}" -interaction=nonstopmode main.tex`, { 
        cwd: latexDir,
        stdio: 'inherit'
    });
    
    console.log("\n✓ Compilation successful!");
} catch (error) {
    console.error("\n✗ Compilation failed:", error.message);
    process.exit(1);
}
