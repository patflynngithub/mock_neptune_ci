! created:  5/23/22

program neptune

use neptune_mod

implicit none

integer :: num_cmdline_args

num_cmdline_args = command_argument_count()

if (num_cmdline_args /= 3) then
   write(*,*) "# of command line arguments: ", num_cmdline_args
   write(*,*) "Error: exactly three command line parameters are req'd in the following order"
   write(*,*) "       - succeed/fail            (first parameter)"
   write(*,*) "                 (succeed: exit code 0 after producing output and timing)"
   write(*,*) "                 (fail:    immediate exit code 1 before producing output"
   write(*,*) "                           and timing)"
   write(*,*) "       - output_matrix_file_*    (second parameter)"
   write(*,*) "             * = none, error, accurate, or inaccurate"
   write(*,*) "                 (none:       produces no output data file and exit code 0)"
   write(*,*) "                 (error:      produces no output data file and exit code 1)"
   write(*,*) "                 (accurate:   produces accurate (all zeros) output"
   write(*,*) "                              data text file and exit code 0)"
   write(*,*) "                 (inaccurate: produces inaccurate (all ones) output"
   write(*,*) "                              data text file and exit code 0)"
   write(*,*) "       - good_timing/bad_timing  (third parameter)"
   write(*,*) "                 (produces artificial standard NEPTUNE timing info"
   write(*,*) "                  in nep.error.000000)"
   stop 2
end if

! is an execution success or failure desired?
call success_or_failure()

!-------------------------

! Is an output matrix file desired? If so, accurate or inaccurate
! (Quality Assurance)?
call output_matrix_file()

!-------------------------

! Is a good (small) or bad (too large) timing desired
! to be output to nep.error.000000? 
call good_or_bad_timing()

end program neptune

