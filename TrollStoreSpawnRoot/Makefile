TARGET := iphone:clang:17.5:14.0
INSTALL_TARGET_PROCESSES = TrollStoreSpawnRoot

ifdef CUSTOM_ARCHS
ARCHS = $(CUSTOM_ARCHS)
else
ARCHS = arm64
endif

TARGET_CODESIGN = ../Exploits/fastPathSign/fastPathSign

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = TrollStoreSpawnRoot

TrollStoreSpawnRoot_FILES = $(wildcard *.m) $(wildcard ../Shared/*.m)
TrollStoreSpawnRoot_FRAMEWORKS = UIKit CoreGraphics CoreServices CoreTelephony
TrollStoreSpawnRoot_PRIVATE_FRAMEWORKS = Preferences MobileContainerManager
TrollStoreSpawnRoot_CFLAGS = -fobjc-arc -I../Shared
TrollStoreSpawnRoot_CODESIGN_FLAGS = --entitlements entitlements.plist
TrollStoreSpawnRoot_LIBRARIES = root

include $(THEOS_MAKE_PATH)/application.mk
