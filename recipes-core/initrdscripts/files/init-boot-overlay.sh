#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin

ROOT_MOUNT="/rootfs/"
MOUNT="/bin/mount"
UMOUNT="/bin/umount"
ISOLINUX=""

ROOT_DISK=""

# Copied from initramfs-framework. The core of this script probably should be
# turned into initramfs-framework modules to reduce duplication.
udev_daemon() {
	OPTIONS="/sbin/udev/udevd /sbin/udevd /lib/udev/udevd /lib/systemd/systemd-udevd"

	for o in $OPTIONS; do
		if [ -x "$o" ]; then
			echo $o
			return 0
		fi
	done

	return 1
}

_UDEV_DAEMON=`udev_daemon`

early_setup() {
    mkdir -p /proc
    mkdir -p /sys
    mount -t proc proc /proc
    mount -t sysfs sysfs /sys
    mount -t devtmpfs none /dev

    # support modular kernel
    modprobe isofs 2> /dev/null

    mkdir -p /run
    mkdir -p /var/run

    $_UDEV_DAEMON --daemon
    udevadm trigger --action=add
}

read_args() {
    [ -z "$CMDLINE" ] && CMDLINE=`cat /proc/cmdline`
    for arg in $CMDLINE; do
        optarg=`expr "x$arg" : 'x[^=]*=\(.*\)'`
        case $arg in
            lowerfstype=*)
                modprobe $optarg 2> /dev/null ;;
            upperfstype=*)
                modprobe $optarg 2> /dev/null ;;
            lowerdev=*)
                LOWERDEV=$optarg ;;
            upperdev=*)
                UPPERDEV=$optarg ;;
            LABEL=*)
                label=$optarg ;;
            video=*)
                video_mode=$arg ;;
            vga=*)
                vga_mode=$arg ;;
            console=*)
                if [ -z "${console_params}" ]; then
                    console_params=$arg
                else
                    console_params="$console_params $arg"
                fi ;;
            debugshell*)
                if [ -z "$optarg" ]; then
                        shelltimeout=30
                else
                        shelltimeout=$optarg
                fi 
        esac
    done
}

boot_overlay_root() {
    # Watches the udev event queue, and exits if all current events are handled
    udevadm settle --timeout=3 --quiet
    killall "${_UDEV_DAEMON##*/}" 2>/dev/null

    # Move the mount points of some filesystems over to
    # the corresponding directories under the real root filesystem.
    for dir in `awk '/\/dev.* \/run\/media/{print $2}' /proc/mounts`; do
        mkdir -p  ${ROOT_MOUNT}/media/${dir##*/}
        mount -n --move $dir ${ROOT_MOUNT}/media/${dir##*/}
    done
    mount -n --move /proc ${ROOT_MOUNT}/proc
    mount -n --move /sys ${ROOT_MOUNT}/sys
    mount -n --move /dev ${ROOT_MOUNT}/dev

    cd $ROOT_MOUNT

    # busybox switch_root supports -c option
    exec switch_root -c /dev/console $ROOT_MOUNT /sbin/init $CMDLINE ||
        fatal "Couldn't switch_root, dropping to shell"
}

fatal() {
    echo $1 >$CONSOLE
    echo >$CONSOLE
    exec sh
}

early_setup

[ -z "$CONSOLE" ] && CONSOLE="/dev/console"

read_args

mount_and_boot() {
    mkdir $ROOT_MOUNT

    mkdir -p /rootfs.ro /rootfs.rw
    mount -oro $LOWERDEV /rootfs.ro || fatal "Couldn't mount lowerdev $LOWERDEV"
    mount $UPPERDEV /rootfs.rw || fatal "Couldn't mount upperdev $UPPERDEV"
    mkdir -p /rootfs.rw/root
    mkdir -p /rootfs.rw/work
    mount -t overlay -o "lowerdir=/rootfs.ro,upperdir=/rootfs.rw/root,workdir=/rootfs.rw/work" overlay $ROOT_MOUNT
    mkdir -p $ROOT_MOUNT/rootfs.ro $ROOT_MOUNT/rootfs.rw
    mount --move /rootfs.ro $ROOT_MOUNT/rootfs.ro
    mount --move /rootfs.rw $ROOT_MOUNT/rootfs.rw

    boot_overlay_root
}

case $label in
    boot)
	mount_and_boot
	;;
    *)
	# Not sure what boot label is provided.  Try to boot to avoid locking up.
	mount_and_boot
	;;
esac
