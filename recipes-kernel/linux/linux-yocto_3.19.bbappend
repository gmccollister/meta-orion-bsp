FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

KBRANCH_orionlxm = "standard/base"

SRCREV_machine_orionlxm ?= "31b35da6a5c8a2b162f6c33202e9b64dd13757d5"

COMPATIBLE_MACHINE_orionlxm = "orionlxm"

SRC_URI_orionlxm = "git://git.yoctoproject.org/linux-yocto-3.19.git;protocol=git;nocheckout=1;branch=${KBRANCH},${KMETA};name=machine,meta"
SRC_URI_orionlxm += "file://am335x.cfg"
