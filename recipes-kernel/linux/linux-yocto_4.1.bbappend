FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

KBRANCH_orionlxm = "standard/base"

SRCREV_machine_orionlxm ?= "b036026dd005b8995924bceb75a110e41842aba5"

COMPATIBLE_MACHINE_orionlxm = "orionlxm"

SRC_URI_prepend_orionlxm = "file://defconfig "

SRC_URI_append_intel-core2-32 = " file://emenlow.cfg \
	file://0001-Revert-ACPI-PNP-Reserve-ACPI-resources-at-the-fs_ini.patch \
	file://0001-gma500-enable-spread-spectrum-mode.patch \
	file://0002-gma500-Don-t-use-panel_fixed_mode.patch"
