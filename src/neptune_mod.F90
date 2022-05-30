module neptune_mod

implicit none

contains

! Is execution success or failure desired?
!
! Specified via 1st command line parameter with possible values:
! succeed/fail
!
subroutine success_or_failure()

   character(10) :: param
   
   call get_command_argument(1,param)
   
   if (trim(adjustl(param)) == "succeed") then
     write(*,*) "successful execution"
     return
   else if (trim(adjustl(param)) == "fail") then
     write(*,*) "execution failure"
     stop 1 
   else
      write(*,*) "Error: 1st command line parameter must be succeed or fail"
      stop 2
   endif

end subroutine success_or_failure

! Outputs a baseline accurate numeric matrix text file and a data result
! numeric matrix text file.
! Is an output numeric matrix text file desired? If so, accurate or
! inaccurate (Quality Assurance)?
! Also, can instead indicate that want to simulate that writing the file
! generated an
! error.
!
! Is indicated by 2nd command line parameter:
!
!   output_matrix_file_none       (error code = 0)
!   output_matrix_file_accurate   (error code = 0)
!   output_matrix_file_inaccurate (error code = 0)
!   output_matrix_file_error      (error code = 1)
!
subroutine output_matrix_file()

   character(30) :: param
   integer       :: matrix_value
   integer       :: unit_num
   
   ! get command argument to see if and how should output matrix file
   call get_command_argument(2, param)
   
   if (trim(adjustl(param)) == "output_matrix_file_error") then
      write(*,*) "OVERRIDING request for successful execution"
      write(*,*) "error creating/writing matrix file (error by request)"
      stop 1
   else if (trim(adjustl(param)) == "output_matrix_file_none") then
      write(*,*) "not outputting matrix file by request"
      return
   else if (trim(adjustl(param)) == "output_matrix_file_accurate") then
      write(*,*) "outputting accurate matrix file by request"
      matrix_value = 0
   else if (trim(adjustl(param)) == "output_matrix_file_inaccurate") then
      write(*,*) "outputting inaccurate matrix file by request"
      matrix_value = 1
   else
      write(*,*) "error: output matrix command line parameter invalid"
      stop 2
   endif

   ! output baseline accurate numeric matrix text file to compare against
   ! - all zeroes for accurate matrix
   unit_num = 1
   open(unit_num, file="baseline_matrix.txt")
   write(unit_num,*) 0,0,0 
   write(unit_num,*) 0,0,0 
   write(unit_num,*) 0,0,0 
   close(unit_num)

   ! output data result numeric matrix text file
   ! - all zeroes for accurate matrix (good QA)
   ! - all ones for inaccurate matrix (bad QA)
   unit_num = 1
   open(unit_num, file="data_result_matrix.txt")
   write(unit_num,*) matrix_value, matrix_value, matrix_value
   write(unit_num,*) matrix_value, matrix_value, matrix_value
   write(unit_num,*) matrix_value, matrix_value, matrix_value
   close(unit_num)
   
end subroutine output_matrix_file

subroutine good_or_bad_timing()

   character(30) :: param
   integer       :: timing
   integer       :: unit_num
   
   ! get command argument to see if should simulate good or bad timing
   call get_command_argument(3, param)
   
   if (trim(adjustl(param)) == "good_timing") then
      write(*,*) "good timing requested"
      timing = 50
   else if (trim(adjustl(param)) == "bad_timing") then
      write(*,*) "bad timing requested"
      timing = 5000
   else
      write(*,*) "error: third parameter should be good_timing or bad_timing"
      stop 2
   endif

   ! output timing to nep.error.000000 file
   unit_num = 1
   open(unit_num, file="nep.error.000000")
  
   write(unit_num,*) "instance               1"
   write(unit_num,*) "maxval(te)", timing
   write(unit_num,*) "minval(te)", timing
   write(unit_num,*) "all      4   6   9"
   write(unit_num,*) "**NEPTUNE Simulation Finished**"
   write(unit_num,*) "neptune_fcst done"

   close(unit_num)

end subroutine good_or_bad_timing

end module neptune_mod
