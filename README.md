Description
===========

This cookbook exists to generically define and create filesystems with the minimum of inputs.

This cookbook supports four main types of block devices:

normal `device` - drives, ssds, volumes presented by HBAs etc
device ID `uuid` - mostly found on drives / known block IDs.
lvm Volume Groups `vg` - found on systems using LVM.
file-backed `file` - created dynamically and looped back - will not come up on reboot, but we will try to remount existing `file` storage in chef.

We will try to create filesystems in two ways: through keys found in node data, or by being called directly with the `filesystems_create` provider. See the example recipe.

Requirements
============

* xfs cookbook when building xfs filesystems
* lvm cookbook when creating logical volumes
* package #{fstype}progs to support your chosen fstype. We provide some defaults, too.

Main Attributes
===============

##### `filesystems`  
Hash of filesytems to setup
##### `node[:filesystems]` keys:
Each filesytem's key is the FS `label`: This explains each key in a filesystems entry. The label must not exceed 12 characters.

We also let you use your own top-level key if you want - see the default recipe and example recipe.

Filesystem Backing Location keys
================================

##### `device`
Path to the device to create the filesystem upon.
##### `uuid`
UUID of the device to create the filesystem upon.
##### `file`
Path to the file-backed storage to be used for a loopback device. If not present it will be created, as long as a size is given.
##### `vg`
Name of the LVM volume group use as backing store for a logical volume. If not present it will be created, as long as a size is given.

If none of these are present then we try to find a device at the label itself.

Filesystem Creation Options
===========================

##### `fstype` [xfs|ocfs2|ext3|ext4|etc] (default: ext3)
The type of filesystem to be created.
##### `mkfs_options` unique for each filesystem.
Options to pass to mkfs at creation time.

Filesystem Backing Options
==========================

##### `size`
The size, only used for filesystems backed by `vg` and `file` storage. If vg then a number suffixied by the scale [g|m|t|p], if a file then just a number [megabytes].
##### `sparse` Boolean (default: true)
Sparse file creation, used by the `file` storage, by default we use this for speed, but you may not want that.
##### `stripes` optional.
The stripes, only used for filesystems backed by `vg` aka LVM storage.
##### `mirrors` optional.
The mirrors, only used for filesystems backed by `vg` aka LVM storage. 

Filesystem Mounting Options
===========================

##### `mount` /path/to/mount
Path to mount the filesystem. (If present we will mount the filesystem - this is rather important)
##### `options` rw,noatime,defaults (default: defaults)
Options to mount with and add to the fstab.
##### `dump` 0|1|2 (default: 0)
Dump entry for fstab
##### `pass` 0|1|2 (default: 0)
Pass entry for fstab
##### `user` user name
Owner of the mountpoint, otherwise we use the chef default. We will not try to create users. You should use the user cookbook for that.
##### `group` group name
Group of the mountpoint, otherwise we use the chef default. We will not try to create groups. You should use the user cookbook for that.
##### `mode` 775
Mode of the mountpoint, otherwise we use the chef default.

Filesystem Package and Recipe Options
=====================================

##### `package` Package name to install, if specified.
Used to support the filesystem
##### `recipe` Recipe to run, if specified - for future use, not currently supported from the lwrp.
Used to support the filesystem

Atypical Behaviour Modifiers
============================

##### `force` Boolean (default: false)
Set to true we unsafely create filesystems even if they already exist.
##### `mkstorage` Boolean (default: true)
Set to false to avoid creating logical volumes or file-backed storage.
##### `mkfs` Boolean (default: true)
Set to false to disable creation of the filesystem.
##### `nomount` Boolean (default: false)
Set to true to disable mounting of the filesystem.
##### `noenable` Boolean (default: false)
Set to true to disable adding to fstab.

Usage
=====

````JSON
{
 "filesystems": { 
   "testfs1": {
     "device": "/dev/sdb"
     "mount": "/db",
     "fstype", "xfs",
     "optons": "noatime,nobarrier",
     "mkfs_options": "-d sunit=128,swidth=2048"
   },
   "applv1": {
     "mount": "/logical1",
     "fstype", "ext4",
     "vg": "standardvg",
     "size": "20G"
   },
   "cluster_01": {
     "fstype": "ocfs2",
     "device": "/dev/mpath/ocfs01",
     "mount": "/mnt/test"
    },
   "filebacked": {
     "file": "/mnt/filesystem-on-a-filesystem.file",
     "mount": "/mnt/filesystem-on-a-filesystem",
     "modfstab": "false",
     "size": "20000"
    }
  }
}
````

Authors
=======

* Alex Trull <cookbooks.atrullmdsol@trull.org>
* Jesse Nelson <spheromak@gmail.com> source of the original cookbook.
