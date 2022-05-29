import numpy as np
import sys
from os.path import exists

# ------------------------------------------------------------

# Compares the data in two data result text files
#
# A data result text file is assumed to only hold a numeric
# matrix that can be read in by numpy

# ------------------------------------------------------------

# Read in command line

if not len(sys.argv) == 3:
   print("Error: improper command line format")
   print("Should be: python", sys.argv[0], "path_filename1 path_filename2")
   sys.exit(1)

# path and filename of data text files to compare
path_filename1 = sys.argv[1]
path_filename2 = sys.argv[2]

# ------------------------------------------------------------

file_exists = exists(path_filename1)
if not file_exists:
  print(path_filename1, " doesn't exist")
  sys.exit(1)

file_exists = exists(path_filename2)
if not file_exists:
  print(path_filename2, " doesn't exist")
  sys.exit(1)

f1 = open(path_filename1, "r")
f2 = open(path_filename2, "r")

data1 = np.loadtxt(f1)
data2 = np.loadtxt(f2)
matrix_diff = data1 - data2

all_zeros = np.all(matrix_diff==0)

if all_zeros:
  print("data is accurate")
else:
  print("data is inaccurate")

