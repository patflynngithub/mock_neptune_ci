# Included makefile for build settings that are GNU compiler-specific
#
# There are separate sections for settings that apply to all
# platforms/cpus and for settings that don't apply to all
# platforms/cpus

# The comments at the beginnings of build settings sections
# are suggestions on what settings to place in them. Following
# these suggestions is helpful to maintaining clarity of the
# build system. However, feel free to make exceptions for
# individual settings if it makes sense to do so.

COMPILER_SPECIFIC_MAKEFILE := $(lastword $(MAKEFILE_LIST))
$(info ... including COMPILER-SPECIFIC BUILD SETTINGS MAKEFILE: $(COMPILER_SPECIFIC_MAKEFILE))

# ==========================================================
#
# Place here build settings that are both compiler-specific
# and platform-specific (and/or cpu-specific). This could be
# in the form of a variable definition or appending to an
# earlier defined variable.
#
# Can also do this in the last section of this file.
#
# Example:
#
#     ifeq ($(NEPTUNE_CPU), broadwell)
#        ... := ...
#        ... += ...
#     endif

# no settings here yet

# ==========================================================
#
# Place build settings here that are compiler-specific and
# apply to ALL platforms/cpus in the NEPTUNE build system
# that support the compiler.  This could be in the form of
# a variable definition or appending to an earlier defined
# variable.
#
# In special circumstances, when it’s the only, best, or clearest
# way to get the build to work, build settings that are both
# compiler-specific and platform-specific (and/or cpu-specific)
# could also be placed in this section (rather than in the first or
# last build settings sections of this file)

AR := ar

# ==========================================================
#
# Place here build settings that are both compiler-specific
# and platform-specific (and/or cpu-specific). This could be
# a variable definition or appending to an earlier defined
# variable. Can also do this in the first build settings
# section of this file
#
# Following these build settings, there may be additional
# compiler-specific build settings that apply to all platforms/cpus
# because they need to be set after the platform- and/or
# cpu-specific build settings set in this section.
#
# Also, if needed, in this section one can overwrite
# previous variable definitions

CC := mpicc
ifeq ($(NEPTUNE_PLATFORM),anniesavoy)  # John M's system with custom wrappers for intel MPI
  FC := mpigfortran10
  LD := $(FC)
else ifeq ($(NEPTUNE_PLATFORM),CI)  # for Github.com CI server
  CC  := gcc
  CXX := g++
  FC  := gfortran
  LD  := $(FC)
else
  FC := mpif90
  LD := $(FC)
endif

