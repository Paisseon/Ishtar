SYSROOT = $(THEOS)/sdks/iPhoneOS16.0.sdk/
ARCHS = arm64
TARGET = iphone:clang:latest:12.2

FINALPACKAGE = 1
DEBUG = 0
THEOS_LEAN_AND_MEAN = 1
FOR_RELEASE = 1
USING_JINX = 1

INSTALL_TARGET_PROCESSES = Choices

LIBRARY_NAME = Z_Ishtar
$(LIBRARY_NAME)_FILES = Sources/load.s $(shell find Sources/Ishtar -name '*.swift')
$(LIBRARY_NAME)_SWIFTFLAGS = -ISources/$(LIBRARY_NAME)C/include

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/library.mk
