FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

KBRANCH_orionlxm = "standard/base"
KBRANCH_emenlow-noemgd = "standard/base"

SRCREV_machine_orionlxm ?= "31b35da6a5c8a2b162f6c33202e9b64dd13757d5"
SRCREV_machine_emenlow-noemgd ?= "31b35da6a5c8a2b162f6c33202e9b64dd13757d5"

COMPATIBLE_MACHINE_orionlxm = "orionlxm"
COMPATIBLE_MACHINE_emenlow-noemgd = "emenlow-noemgd"

SRC_URI_orionlxm = "git://git.yoctoproject.org/linux-yocto-3.19.git;protocol=git;nocheckout=1;branch=${KBRANCH},${KMETA};name=machine,meta"
SRC_URI_orionlxm += "file://am335x.cfg"

SRC_URI_emenlow-noemgd = "git://git.yoctoproject.org/linux-yocto-3.19.git;protocol=git;nocheckout=1;branch=${KBRANCH},${KMETA};name=machine,meta"
SRC_URI_emenlow-noemgd += "file://0001-gma500-enable-spread-spectrum-mode.patch"
SRC_URI_emenlow-noemgd += "file://0002-gma500-Don-t-use-panel_fixed_mode.patch"
SRC_URI_emenlow-noemgd += "file://emenlow.cfg"
