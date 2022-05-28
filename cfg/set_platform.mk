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
  ifeq ($(findstring sandy,$(NEPTUNE_PLATFORM)),sandy)
     override NEPTUNE_PLATFORM := sandy
  else ifeq ($(findstring narwhal,$(NEPTUNE_PLATFORM)),narwhal)
     override NEPTUNE_PLATFORM := narwhal
  else ifeq ($(findstring gaffney,$(NEPTUNE_PLATFORM)),gaffney)
     override NEPTUNE_PLATFORM := gaffney
  else ifeq ($(findstring mayhem,$(NEPTUNE_PLATFORM)),mayhem)
     override NEPTUNE_PLATFORM := mayhem
  else ifeq ($(findstring anniesavoy,$(NEPTUNE_PLATFORM)),anniesavoy)
     override NEPTUNE_PLATFORM := anniesavoy
  else
     $(error ERROR: NEPTUNE_PLATFORM has unsupported value of $(NEPTUNE_PLATFORM))
  endif
endif

$(info NEPTUNE_PLATFORM (modified): $(NEPTUNE_PLATFORM))

PLATFORM_INCLUDE_FILE := $(addsuffix $(NEPTUNE_PLATFORM), $(CONFIG_DIR)/config.platform.)

