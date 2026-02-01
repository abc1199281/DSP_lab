import os
from pathlib import Path

def find_next_to_convert(root_dir):
    """
    Finds the next .m file to be converted by checking for a corresponding .py file.
    Prints the path of the next file or "NO_MORE_FILES".
    """
    matlab_files = sorted(Path(root_dir).rglob('*.m'))
    
    # Create a set of stems for all existing .py files for quick lookup
    converted_stems = {p.stem for p in Path(root_dir).rglob('*.py')}

    # Manual mapping for files with different names
    name_map = {
        "BasicSNR_estimate": "BasicSNR_estimate.m",
        "CRLB_Freq": "CRLB_Freq.m",
        "EstimatorOfMean": "EstimatorOfMean.m",
        "Quantizing": "Quantizing.m",
        "SNR_test": "SNR_test.m",
        "Test": "Test.m",
        "test": "test.m", # Handle lowercase test.m
        "estimator_of_mean": "EstimatorOfMean.m", # New mapping
    }
    # Add stems from the name map to the converted set
    converted_stems.update(name_map.keys())


    for m_file in matlab_files:
        # Check if the stem of the .m file (e.g., "lms1") is in our set of converted stems
        if m_file.stem not in converted_stems:
            print(m_file, flush=True)
            return

    # If the loop completes, no more files were found
    print("NO_MORE_FILES", flush=True)

if __name__ == "__main__":
    dsp_lab_path = "." # Run from within the DSP_lab directory
    find_next_to_convert(dsp_lab_path)
