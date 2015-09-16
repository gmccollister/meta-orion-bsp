FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

KBRANCH_orionlxm = "standard/base"
KBRANCH_emenlow-noemgd = "standard/base"

SRCREV_machine_orionlxm ?= "d5d30ba4d20e65c15df624ffce7a5cd38150348b"
SRCREV_machine_emenlow-noemgd ?= "d5d30ba4d20e65c15df624ffce7a5cd38150348b"

COMPATIBLE_MACHINE_orionlxm = "orionlxm"
COMPATIBLE_MACHINE_emenlow-noemgd = "emenlow-noemgd"

SRC_URI_orionlxm = "git://git.yoctoproject.org/linux-yocto-3.19.git;protocol=git;nocheckout=1;branch=${KBRANCH},${KMETA};name=machine,meta"
SRC_URI_orionlxm += "file://defconfig"

SRC_URI_emenlow-noemgd = "git://git.yoctoproject.org/linux-yocto-3.19.git;protocol=git;nocheckout=1;branch=${KBRANCH},${KMETA};name=machine,meta"
SRC_URI_emenlow-noemgd += "file://0001-gma500-enable-spread-spectrum-mode.patch"
SRC_URI_emenlow-noemgd += "file://0002-gma500-Don-t-use-panel_fixed_mode.patch"
SRC_URI_emenlow-noemgd += "file://0003-Call-acpi_reserve_resources-earlier.patch"
SRC_URI_emenlow-noemgd += "file://emenlow.cfg"
