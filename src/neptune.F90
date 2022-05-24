! created:  5/23/22

program neptune

use neptune_mod

implicit none

integer :: num_cmdline_args

num_cmdline_args = command_argument_count()

if (num_cmdline_args /= 3) then
   write(*,*) "# of command line arguments: ", num_cmdline_args
   write(*,*) "Error: exactly three command line parameters are required in the following order"
   write(*,*) "       - fail/succeed            (first parameter)"
   write(*,*) "       - output_matrix_file_*    (second parameter)"
   write(*,*) "             * = none, accurate, inaccurate or error"
   write(*,*) "       - good_timing/bad_timing  (third parameter)"
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

