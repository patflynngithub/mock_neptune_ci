# Mock NEPTUNE CI repository

This repository is a mockup of the already existing CI process in the NEPTUNE repository. It is created for the purpose of testing changes to the CI process that would, at least initially, be cumbersome or time consuming to test in the real NEPTUNE repository. An example might be changing a repository setting (that affects the CI process) on the GitHub server. Another example might be making changes to a GitHub Actions script. Testing these changes using the mockup is much faster, avoiding the time of building and testing the full NEPTUNE. This will result in a quick edit/execute/evaluation cycle that will allow for better understanding the nuances about changes to the CI process. There will, of course, be some CI process changes that will not be able to be tested using this mockup.

The mockup doesn't contain any NEPTUNE Fortran/C/C++ code, but it does contain enough of NEPTUNE's Make and Bash shell code to duplicate the structure and flow of the NEPTUNE CI process. It uses most of the same directory and file names. It builds the executable, sets up and executes a test, differences the data results from a baseline, evaluates the data difference results, and checks the timing of the execution. Anyone familiar with the real NEPTUNE CI process code will find the mockup very familiar.

As of the creation of this README (5/30/22), there is one mock test in *ci/mock_test*. Just like a real NEPTUNE CI process test, execute this mock test via:

    ./run_ci.sh

In *ci/mock_test/run_ci.sh*, the *run_test* bash function is called with parameters that determine whether the test executes successfully (zero exit code), produces "accurate" data results, and executes fast enough:

     run_test ${CI_DIR} ${CI_RUN} succeed output_matrix_file_accurate good_timing

See *src/neptune.F90* for the possible values of the last three parameters. Also, to see some of what is actually happening below the surface of the mockup (it's very different from the real NEPTUNE CI process), see *src/neptune_mod.F90*. An example is that no HDF5 data result file is created (keeps the mockup simpler); instead a numeric data result text file is created that is later read by the *compare_test* bash function.

If you want to create another mock test, don't change the original test (*ci/mock_test*). Rather, create another test directory in *ci/* and copy the contents of *ci/mock_test/* to it, modifying it as needed.

