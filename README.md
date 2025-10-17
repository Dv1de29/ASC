# ASC
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/Dv1de29/ASC)

This repository contains a project that simulates a basic file manager's storage allocation system using 32-bit x86 assembly language. The simulation handles the logic for allocating, finding, deleting, and defragmenting "files" within a modeled storage space.

The project features two distinct implementations: one using a unidimensional array and another a bidimensional matrix to represent the storage medium.

## Key Features

*   **File Addition (`addf`):** Allocates a contiguous block of memory for a new "file" based on a given ID and size.
*   **File Retrieval (`getf`):** Finds the location (start and end indices) of a file by its unique ID.
*   **File Deletion (`delf`):** Deallocates the blocks associated with a file, marking the space as free.
*   **Defragmentation (`dfgf`):** Reorganizes the storage by moving allocated blocks to consolidate free space and eliminate fragmentation.
*   **Directory Scanning:** The bidimensional model can scan a host system directory, calculate file properties, and add them to the simulated storage.

## Implementations

### 1. Unidimensional Model (`151_Barbu_David-Florian_0.s`)

This is a fundamental implementation where the storage space is modeled as a large, one-dimensional array. It provides a foundational understanding of the allocation logic. Operations are performed by reading commands and file data from standard input.

### 2. Bidimensional Model (`151_Barbu_David-Florian_1.s`)

A more advanced version that represents storage as a two-dimensional grid (a matrix of blocks). This model is more complex and closer to how disk sectors might be logically organized. It expands on the core features and adds the capability to interact with the real file system by reading a directory's contents.

## Building and Running

You can compile the assembly source files using `gcc` with 32-bit support. It's recommended to rename the executables for use with the checker script.

```bash
# Compile the unidimensional model (assuming it's renamed to task1.s)
gcc -m32 -o task1 151_Barbu_David-Florian_0.s

# Compile the bidimensional model (assuming it's renamed to task2.s)
gcc -m32 -o task2 151_Barbu_David-Florian_1.s
```

The programs read a sequence of operations from standard input.

## Testing

The repository includes a Python test script, `checker.py`, to automate the verification of both implementations. The script executes a series of predefined tests for each task and compares the program's output with the expected results.

To run the checker, first, ensure you have compiled the source files into executables named `task1` and `task2`. Then, run the script from your terminal:

```bash
# Check the unidimensional implementation
python3 checker.py task1

# Check the bidimensional implementation
python3 checker.py task2

# Run all defined checks
python3 checker.py
