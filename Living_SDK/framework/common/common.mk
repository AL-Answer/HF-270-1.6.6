NAME := framework

$(NAME)_TYPE := framework
$(NAME)_SOURCES    := main.c version.c

GLOBAL_DEFINES += AOS_FRAMEWORK_COMMON

ifneq (,${BINS})
        GLOBAL_CFLAGS += -DSYSINFO_OS_BINS
endif

CONFIG_SYSINFO_APP_VERSION ?= app-1.0.0-$(CURRENT_TIME)
$(info app_version:${CONFIG_SYSINFO_APP_VERSION})
GLOBAL_CFLAGS += -DSYSINFO_APP_VERSION=\"$(CONFIG_SYSINFO_APP_VERSION)\"
