# Establish platform that is being built upon

# Can alternatively set by environment or command-line variable

NEPTUNE_PLATFORM ?= $(shell hostname)
$(info NEPTUNE_PLATFORM: $(NEPTUNE_PLATFORM))

# override allows the platform to be provided by Make
# command-line variable, if needed; for instance, could
# want to try one of the existng below platforms on a
# new platform
#
ifdef CI    # CI is Github-provided environment variable
            # indicating execution on Github
   override NEPTUNE_PLATFORM := CI
else

  # Some of the config.platform.* files (e.g., narwahl, anniesavoy, etc.)
  # have been eliminated from this GitHub NEPTUNE CI mockup. If needed
  # they be restored from the actual NEPTUNE repository, albeit
  # in stripped down form suitable for this mockup (see
  # config.platform.sandy for stripped down example).

  ifeq ($(findstring sandy,$(NEPTUNE_PLATFORM)),sandy)
     override NEPTUNE_PLATFORM := sandy
  else
     $(error ERROR: NEPTUNE_PLATFORM has unsupported value of $(NEPTUNE_PLATFORM))
  endif
endif

$(info NEPTUNE_PLATFORM (modified): $(NEPTUNE_PLATFORM))

PLATFORM_INCLUDE_FILE := $(addsuffix $(NEPTUNE_PLATFORM), $(CONFIG_DIR)/config.platform.)

