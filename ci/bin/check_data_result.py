import numpy as np
import sys
from os.path import exists

# ------------------------------------------------------------

# Read in command line

if not len(sys.argv) == 2:
   print("Error: improper command line format")
   print("Should be: python", sys.argv[0], "path_and_filename_of_data_result")
   sys.exit(1)

path_and_filename = sys.argv[1]

# ------------------------------------------------------------

file_exists = exists(path_and_filename)
if not file_exists:
  print(path_and_filename, " doesn't exist")
  sys.exit(1) 

data = np.loadtxt(path_and_filename)
print(data)
matrix_sum = data.sum()
print("matrix sum = ", matrix_sum)

if matrix_sum == 0:
  # zero matrix is treated as accurate
  print("data is accurate")
  exit_code = 0
else:
  # non-zero matrix is treated as inaccurate
  print("data is inaccurate")
  exit_code = 1

sys.exit(exit_code)
