# The top-level Makefile for the NEPTUNE build system

# Build system structure:
#
#   Makefile
#      -> include config.platform.xxx
#          -> include config.general_settings
#              -> include config.compiler.yyy

# ------------------------------------------------------

# GUIDELINES FOR USING NEPTUNE BUILD SYSTEM

# Variables
#
#    - If you wish to understand the makefile variables behavior
#      that underlies these variable guidelines, consult the
#      "Info on variables in Make/makefiles" section at the
#      end of this file.
#
#    - A makefile variable is created for each environment
#      variable defined when Make is called.
#
#    - A makefile variable is created for each variable
#      defined on the Make command line. It is recommended to
#      use the Make ":=" operator unless there is a strong
#      reason to use the Make "=" operator. Command-line
#      variables take precedence over environment variables
#      of the same name.
#
#    - In order to overwrite a variable defined inside the
#      NEPTUNE build system makefiles with an "=" or ":=",
#      the variable must be provided by a Make command-line
#      variable (with "=" or ":=), not an environment variable.
#      The environment variable value would be overwritten by
#      the variable's definition inside the makefile.
#
#    - For the Make "?=" "define if not defined" operator, the
#      definition does not occur regardless of whether the
#      previous definition occured inside the makefile or via
#      the command-line or an environment variable.
#
#    - Some variables defined inside the NEPTUNE build system
#      makefiles are defined using the "+=" append operator,
#      even for the first definition of them (e.g., CPPFLAGS).
#
#      If such a variable's value is initially provided via the
#      command-line (with "=" or ":="), then none of the "+="
#      operations for this variable inside the makefiles will
#      have any affect.
#
#      On the other hand, if such a variable's value is initially
#      provided via an environment variable (with "="), then
#      all of the "+=" operations inside the makefiles will
#      append their values to the environment variable's value
#      as expected.
#

# ------------------------------------------------------

TOP_LEVEL_MAKEFILE := $(lastword $(MAKEFILE_LIST))
$(info ... entering TOP-LEVEL NEPTUNE MAKEFILE: $(TOP_LEVEL_MAKEFILE))

export NEPTUNE_DIR := $(CURDIR)
$(info NEPTUNE_DIR: $(NEPTUNE_DIR))

# Directories that are part of the git repository are
# defined with underscore in name. (Other directories
# created during build are defined without underscore
# in ./cfg/config.general_settings)

export CONFIG_DIR         ?= $(NEPTUNE_DIR)/cfg
export SRC_DIR            ?= $(NEPTUNE_DIR)/src

# ----
#
export NEPTUNE_BUILD_DIR  ?= $(NEPTUNE_DIR)/build

# This allows for a relative path to be specified for NEPTUNE_BUILD_DIR.
# Will convert a relative path to an absolute path so that it can be used
# in any build (i.e., Jedi, NEPTUNE, CCPP, IOAPI, DSAPI)
override NEPTUNE_BUILD_DIR := $(shell readlink -f $(NEPTUNE_BUILD_DIR))
$(info NEPTUNE_BUILD_DIR: $(NEPTUNE_BUILD_DIR))

# Directories that will be created during the build.
# Define here so that config files can use.
OBJDIR := $(NEPTUNE_BUILD_DIR)/objdir
INCDIR := $(NEPTUNE_BUILD_DIR)/include
LIBDIR := $(NEPTUNE_BUILD_DIR)/lib
BINDIR := $(NEPTUNE_BUILD_DIR)/bin

# ------------------------------------------------------

# These variables can optionally be set via environment
# or command-line variables before calling Makefile.
# If they aren't set this way, then they are given
# default values here.

# These variables are the more common ones that one might
# want to set via environment or command-line variables.
# There are other variables in the NEPTUNE build system that
# are not listed here that one might also wish to change the
# value of by using environment or command-line variables
# (perhaps for testing, etc.); these can be ascertained by
# examining the build system makefile code.


# ======================================================

# Moved default target here to avoid being preempted by 
# targets that appear in the include files, JM 2021111
default_target : neptune_fcst

include $(CONFIG_DIR)/set_platform.mk
include $(PLATFORM_INCLUDE_FILE)

# ======================================================

$(info ... reentering TOP-LEVEL NEPTUNE MAKEFILE: $(TOP_LEVEL_MAKEFILE))

$(info CC  = $(CC))
$(info CXX = $(CXX))
$(info FC  = $(FC))
$(info LD  = $(LD))

# Patrick Flynn 6/18/2021
# This is for the future possbility of adding a Fortran module
# that stores build settings used to do a particular NEPTUNE
# build. When executing NEPTUNE, the build settings could be 
# output when an execution command-line switch is provided.
#
# First effort at outputing makefile variables to a text file
# 
# $(foreach var,$(sort $(.VARIABLES)),$(shell echo '$(var) = $($(var))' >> output.txt))

# ======================================================

# Make rules
# ----------

# Note that some of the recipes are self-recursive w.r.t.
# the current makefile

.SUFFIXES:            # Delete the default suffixes
.SUFFIXES: .c .F90 .inc .o .h   # Define our suffix list

# ------------------------------------------------------

all : neptune_fcst

neptune_fcst:
	mkdir -p $(INCDIR)
	mkdir -p $(OBJDIR)
	mkdir -p $(LIBDIR)
	mkdir -p $(BINDIR)
	$(FC) $(FFLAGS) -c -o $(OBJDIR)/neptune_mod.o $(SRC_DIR)/neptune_mod.F90
	$(FC) $(FFLAGS) -o $(BINDIR)/neptune_fcst.exe $(SRC_DIR)/neptune.F90 $(OBJDIR)/neptune_mod.o

clean:
	rm -rf $(NEPTUNE_BUILD_DIR)
	rm -f  make.log

deepclean: clean

# ======================================================

# Info on variables in Make/makefiles

# Variables in a makefile come from three different sources.
# The standard source is a variable definition inside of
# the makefile; this is often called a "makefile variable."
# The other two sources are environment and command-line
# variables. When Make is called, all current environment
# variables are automatically duplicated in the makefile.
# When Make is called, variable defintions can be included
# on the command-line.
#
# Variables defined at the Make command-line take precedence
# over environment variables of the same name. Variables
# defined inside a makefile automatically overwrite
# environment variables of the same name. However, variables
# defined inside a makefile do not automatically overwrite
# command-line variables of the same name.

# =,:=
#
# "=" defines recursively-expanded variables. This means
# that any variable references on the right-hand side of
# the definition are not expanded until the left-hand side
# variable is actually used later in the makefile. This
# can be powerful but tricky to use and hard to debug.
# It is recommended to use recursively-expanded variables
# only when necessary.
#
# ":=" defines simply-expanded variables that behave like
# variables from traditional programming languages. The
# expression on the right-hand side is fully evaluated
# during the definition, and the result is stored in the
# left-hand side variable.  This means that any variable
# referenced on the right-hand side is expanded before the
# assignment take place. This is the recommended type of
# definition to use unless there is a strong reason to use a
# recursively-expanded variable instead.

# ?=
#
# The Make "?=" conditional assignment operator will assign
# a value to a variable if it is undefined. If a variable is
# previously defined by environment, command-line, or
# makefile, “?=” will not overwrite the previous value.

# +=
#
# The Make "+=" append operator adds the right-hand side
# value to the right end of the left-hand side variable's value.
# If the variable is first defined as an environment variable
# before calling Make, then the append will happen. If the
# variable is first defined as a command-line variable when
# calling Make, then the append will not happen.

