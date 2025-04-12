
import os
import re
import sys

def is_persian(text):
    """Check if text contains Persian characters"""
    # Regular expression for Persian characters
    persian_pattern = re.compile(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
    return bool(persian_pattern.search(text))

def scan_file(file_path):
    """Scan a file for Persian text and return matching lines"""
    matches = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            for i, line in enumerate(f, 1):
                if is_persian(line):
                    matches.append((i, line.strip()))
        return matches
    except Exception as e:
        return [(0, f"Error reading file: {e}")]

def scan_directory(directory, extensions=None):
    """Recursively scan a directory for files containing Persian text"""
    results = {}
    
    if extensions is None:
        extensions = ['.py', '.html', '.txt', '.md', '.json']
    
    for root, _, files in os.walk(directory):
        for file in files:
            # Skip directories like venv, node_modules, etc.
            if any(skip_dir in root for skip_dir in ['.git', 'venv', 'node_modules', '__pycache__']):
                continue
                
            # Check if file has the right extension
            if not any(file.endswith(ext) for ext in extensions):
                continue
                
            file_path = os.path.join(root, file)
            matches = scan_file(file_path)
            
            if matches:
                results[file_path] = matches
    
    return results

def main():
    """Main function to scan for Persian text in code files"""
    directory = "."  # Current directory
    
    print("Scanning for Persian text in files...")
    results = scan_directory(directory)
    
    if not results:
        print("No Persian text found in files.")
        return
    
    print(f"Found Persian text in {len(results)} files:\n")
    
    for file_path, matches in results.items():
        print(f"File: {file_path}")
        print("-" * 70)
        for line_num, line in matches:
            print(f"Line {line_num}: {line}")
        print("\n")
    
    print(f"Total files with Persian text: {len(results)}")
    
if __name__ == "__main__":
    main()
