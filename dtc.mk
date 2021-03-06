#Android makefile to build kernel as a part of Android Build
PERL		= perl

ifeq ($(TARGET_PREBUILT_KERNEL),)
KERNEL_OUT := out/SC01F/SAM/obj
KERNEL_CONFIG := $(KERNEL_OUT)/.config
TARGET_PREBUILT_INT_KERNEL := $(KERNEL_OUT)/arch/arm/boot/zImage
KERNEL_HEADERS_INSTALL := $(KERNEL_OUT)/usr
KERNEL_MODULES_INSTALL := system
KERNEL_MODULES_OUT := $(TARGET_OUT)/lib/modules
KERNEL_IMG=$(KERNEL_OUT)/arch/arm/boot/Image

USE_MODULE ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_MODULES=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))

DTS_NAMES ?= $(shell $(PERL) -e 'while (<>) {$$a = $$1 if /CONFIG_ARCH_((?:MSM|QSD|MPQ)[a-zA-Z0-9]+)=y/; $$r = $$1 if /CONFIG_MSM_SOC_REV_(?!NONE)(\w+)=y/; $$arch = $$arch.lc("$$a$$r ") if /CONFIG_ARCH_((?:MSM|QSD|MPQ)[a-zA-Z0-9]+)=y/} print $$arch;' $(KERNEL_CONFIG))
KERNEL_USE_OF ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_USE_OF=y/) { $$of = "y"; break; } } print $$of;' arch/arm/configs/$(KERNEL_DEFCONFIG))
J_PROJECT ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_SEC_J_PROJECT=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))
JACTIVE_PROJECT ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_SEC_JACTIVE_PROJECT=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))
H_PROJECT ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_SEC_H_PROJECT=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))
LOCALE_JPN ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_SEC_LOCALE_JPN=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))
LOCALE_KOR ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_SEC_LOCALE_KOR=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))
LOCALE_CHN_DUOS ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_MACH_H3GDUOS=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))
VIENNA_PROJECT ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_SEC_VIENNA_PROJECT=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))
LT03_PROJECT ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_SEC_LT03_PROJECT=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))
MONTBLANC_PROJECT ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_SEC_MONTBLANC_PROJECT=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))
F_PROJECT ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_SEC_F_PROJECT=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))
JS_PROJECT ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_SEC_JS_PROJECT=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))
JVE_PROJECT ?= $(shell $(PERL) -e '$$of = "n"; while (<>) { if (/CONFIG_SEC_JVE_PROJECT=y/) { $$of = "y"; break; } } print $$of;' $(KERNEL_CONFIG))

ifeq "$(KERNEL_USE_OF)" "y"
ifeq "$(J_PROJECT)" "y"
DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-ks01*.dts)
endif
ifeq "$(JACTIVE_PROJECT)" "y"
DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-jactive*.dts)
endif

ifeq ("$(H_PROJECT)", "y")
	ifeq ("$(LOCALE_JPN)" , "y")
		DTS_FILES = $(wildcard arch/arm/boot/dts/msm8974-sec-hltejpn*.dts)
	else
		ifeq "$(LOCALE_KOR)" "y"
			DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-hltekor*.dts)
		else
			ifeq "$(LOCALE_CHN_DUOS)" "y"
				DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-h3gchnduos*.dts)
			else
				DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-hlte-*.dts)
			endif
		endif
	endif
endif
ifeq "$(VIENNA_PROJECT)" "y"
DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-vienna*.dts)
endif
ifeq "$(LT03_PROJECT)" "y"
    ifeq "$(LOCALE_KOR)" "y"
        DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-lt03kor-*.dts)
    else
        DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-lt03-*.dts)
    endif
endif
ifeq "$(MONTBLANC_PROJECT)" "y"
DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-montblanc*.dts)
endif
ifeq "$(F_PROJECT)" "y"
DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-flte-*.dts)

    # re-asging for FLTE kor
    ifeq "$(LOCALE_KOR)" "y"
        DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-fltekor-*.dts)
    endif     

endif
ifeq "$(JS_PROJECT)" "y"
	ifeq "$(LOCALE_JPN)" "y"
		DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-js01ltejpn*.dts)
	endif
endif
ifeq "$(JVE_PROJECT)" "y"
DTS_FILES = $(wildcard ./arch/arm/boot/dts/$(DTS_NAME)-sec-jvelte-*.dts)
endif

#DTS_FILES = $(shell find arch/arm/boot/dts/ | grep msm8974-sec-hltejpn.*.dts$)

DTS_FILE = $(lastword $(subst /, ,$(1)))
DTB_FILE = $(addprefix $(KERNEL_OUT)/arch/arm/boot/,$(patsubst %.dts,%.dtb,$(call DTS_FILE,$(1))))
ZIMG_FILE = $(addprefix $(KERNEL_OUT)/arch/arm/boot/,$(patsubst %.dts,%-zImage,$(call DTS_FILE,$(1))))
KERNEL_ZIMG = $(KERNEL_OUT)/arch/arm/boot/zImage
DTC = $(KERNEL_OUT)/scripts/dtc/dtc




define append-dtb
mkdir -p $(KERNEL_OUT)/arch/arm/boot;\
$(foreach DTS_NAME, $(DTS_NAMES), \
   $(foreach d, $(DTS_FILES), \
      $(DTC) -p 1024 -O dtb -o $(call DTB_FILE,$(d)) $(d); \
      cat $(KERNEL_ZIMG) $(call DTB_FILE,$(d)) > $(call ZIMG_FILE,$(d));))
endef
else

define append-dtb
endef
endif

ifeq ($(TARGET_USES_UNCOMPRESSED_KERNEL),true)
$(info Using uncompressed kernel)
TARGET_PREBUILT_KERNEL := $(KERNEL_OUT)/piggy
else
TARGET_PREBUILT_KERNEL := $(TARGET_PREBUILT_INT_KERNEL)
endif

define mv-modules
mdpath=`find $(KERNEL_MODULES_OUT) -type f -name modules.dep`;\
if [ "$$mdpath" != "" ];then\
mpath=`dirname $$mdpath`;\
ko=`find $$mpath/kernel -type f -name *.ko`;\
for i in $$ko; do mv $$i $(KERNEL_MODULES_OUT)/; done;\
fi
endef

define clean-module-folder
mdpath=`find $(KERNEL_MODULES_OUT) -type f -name modules.dep`;\
if [ "$$mdpath" != "" ];then\
mpath=`dirname $$mdpath`; rm -rf $$mpath;\
fi
endef

PHONY += dtc

dtc:
	@echo KERNEL_OUT=$(KERNEL_OUT)
	@echo KERNEL_CONFIG=$(KERNEL_CONFIG)
	@echo TARGET_PREBUILT_INT_KERNEL=$(TARGET_PREBUILT_INT_KERNEL)
	@echo KERNEL_HEADERS_INSTALL=$(KERNEL_HEADERS_INSTALL)
	@echo KERNEL_MODULES_INSTALL=$(KERNEL_MODULES_INSTALL)
	@echo KERNEL_MODULES_OUT=$(KERNEL_MODULES_OUT)
	@echo KERNEL_IMG=$(KERNEL_IMG)
	@echo DTS_NAMES=$(DTS_NAMES)
	@echo KERNEL_USE_OF=$(KERNEL_USE_OF)
	@echo JACTIVE_PROJECT=$(JACTIVE_PROJECT)
	@echo H_PROJECT=$(H_PROJECT)
	@echo LOCALE_JPN=$(LOCALE_JPN)
	@echo LOCALE_KOR=$(LOCALE_KOR)
	@echo LOCALE_CHN_DUOS=$(LOCALE_CHN_DUOS)
	@echo VIENNA_PROJECT=$(VIENNA_PROJECT)
	@echo LT03_PROJECT=$(LT03_PROJECT)
	@echo MONTBLANC_PROJECT=$(MONTBLANC_PROJECT)
	@echo F_PROJECT=$(F_PROJECT)
	@echo JS_PROJECT=$(JS_PROJECT)
	@echo JVE_PROJECT=$(JVE_PROJECT)
	@echo DTS_FILES=$(DTS_FILES)
	@echo DTS_FILE=$(DTS_FILE)
	@echo DTB_FILE=$(DTB_FILE)
	@echo ZIMG_FILE=$(ZIMG_FILE)
	@echo KERNEL_ZIMG=$(KERNEL_ZIMG)
	@echo DTC=$(DTC)
	@echo KERNEL_IMG=$(KERNEL_IMG)
	$(append-dtb)

endif


PHONY += kernel_config
kernel_config: $(KERNEL_OUT)
	$(MAKE) -C kernel O=../$(KERNEL_OUT) ARCH=arm CROSS_COMPILE=arm-eabi- msm8974_sec_defconfig VARIANT_DEFCONFIG=msm8974_sec_hltedcm_defconfig SELINUX_DEFCONFIG=selinux_defconfig SELINUX_LOG_DEFCONFIG=selinux_log_defconfig TIMA_DEFCONFIG=tima_defconfig

PHONY += kernel_config_kdi
kernel_config_kdi: $(KERNEL_OUT)
	$(MAKE)  ARCH=arm CROSS_COMPILE=arm-eabi- msm8974_sec_defconfig VARIANT_DEFCONFIG=msm8974_sec_hltekdi_defconfig SELINUX_DEFCONFIG=selinux_defconfig SELINUX_LOG_DEFCONFIG=selinux_log_defconfig TIMA_DEFCONFIG=tima_defconfig

