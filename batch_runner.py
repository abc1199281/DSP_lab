import subprocess
import sys
import os
from pathlib import Path

# --- Conversion Logic Placeholder ---
# In a real scenario, these would be complex agentic actions.
# Here, we simulate them with placeholder functions.

def convert_file(file_path):
    """
    Placeholder for the agent's conversion logic.
    Creates a dummy .py file and returns its path.
    """
    py_path = Path(file_path).with_suffix('.py')
    try:
        with open(py_path, 'w') as f:
            f.write(f"# Dummy conversion of {Path(file_path).name}\n")
            f.write("print('Hello from the converted file!')\n")
        print(f"Successfully converted {file_path} to {py_path}", flush=True)
        return str(py_path)
    except Exception as e:
        print(f"Error during dummy conversion: {e}", flush=True)
        return None

# --- Main Batch Runner Logic ---

def run_command(command, cwd):
    """Executes a command in a given directory."""
    try:
        subprocess.run(
            command, 
            shell=True, 
            check=True, 
            capture_output=True, 
            text=True,
            cwd=cwd
        )
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {command}", flush=True)
        print(f"Stderr: {e.stderr}", flush=True)
        return False

def main():
    """Main loop for offline batch conversion."""
    print("--- Starting Offline Batch Conversion Mode ---", flush=True)
    
    dsp_lab_path = "." # Script is run from within DSP_lab directory

    while True:
        print("\n----- Finding next file to convert -----", flush=True)
        
        result = subprocess.run(
            ["python3", "convert_next.py"], 
            capture_output=True, 
            text=True,
            cwd=dsp_lab_path
        )
        
        next_file_rel = result.stdout.strip()
        
        if not next_file_rel or "NO_MORE_FILES" in next_file_rel:
            print("--- Done: All convertible files have been processed. ---", flush=True)
            break
            
        print(f"Found next target: {next_file_rel}", flush=True)
        
        # This is where the agent's complex logic would be triggered.
        # For this script, we'll just call the placeholder.
        converted_file_path = convert_file(next_file_rel)
        
        if not converted_file_path:
            print(f"Skipping commit due to conversion failure.", flush=True)
            continue
            
        print(f"----- Committing converted file: {Path(converted_file_path).name} -----", flush=True)
        
        # Git Add and Commit
        if not run_command("git add .", cwd=dsp_lab_path):
            continue
        
        commit_message = f"feat: Auto-convert {Path(next_file_rel).name}"
        if not run_command(f"git commit -m '{commit_message}'", cwd=dsp_lab_path):
            # This might fail if pre-commit reformats the file
            print("Commit failed, likely due to pre-commit hook. Re-adding and retrying...", flush=True)
            if run_command("git add .", cwd=dsp_lab_path) and \
               run_command(f"git commit -m '{commit_message}'", cwd=dsp_lab_path):
                print("Re-commit successful.", flush=True)
            else:
                print("Re-commit also failed. Skipping this file.", flush=True)
                continue
    
    print("\n--- Batch Runner Finished ---", flush=True)

if __name__ == "__main__":
    main()
