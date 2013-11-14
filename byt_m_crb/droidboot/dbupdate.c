#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mount.h>
#include <errno.h>

#include <droidboot_util.h>
#include <droidboot_plugin.h>
#include <stdlib.h>
#include <unistd.h>

#include "fastboot.h"
#include "droidboot.h"

#define MAXFILS 16
#define BOOT_PART "bootloader"

static int rdline(char *ptr)
{
	int cnt = 0;
	char *pos = ptr;
	while (*pos != '\n' && *pos != 0) {
		cnt++;
		pos++;
	}
	*pos = 0;
	return cnt + 1;
}

static int update_droid(Hashmap *params, void *data, unsigned sz)
{
	int cnt, i, ret = -1;
	char *ptr = data;
	const char *bootptn;
	char buf[PATH_MAX];
	Volume *vol;

	/* read in file count */
	i = rdline(ptr);
	cnt = strtol(ptr, NULL, 10);
	if (cnt < 1) {
		pr_error("bad blob format");
		return -1;
	}
	ptr += i;

	pr_debug("dbupdate:  base: %p size: %d cnt: %d\n",  data, sz, cnt);
	if (cnt >= MAXFILS) {
		pr_error("Too many files");
		return -1;
	}

	vol = volume_for_name(BOOT_PART);
	if (!vol) {
		pr_error("Couldn't find bootloader partition. Is your "
			"recovery.fstab valid?\n");
		return -1;
	}
	bootptn = vol->device;

	if (mount_partition_device(bootptn, vol->fs_type, "/boot")) {
		pr_error("Couldn't mount bootloader partition.\n");
		return -1;
	}

	for (i = 0; i < cnt; i++) {
		int ret, len;
		char *idx, *name;
		unsigned char *prog;
		ret = rdline(ptr);
		name = ptr;
		ptr += ret;
		prog = (unsigned char*)ptr;

		idx = index(name, ',');
		if (!idx) {
			pr_error("Bad format %s %d %d\n",name, errno, ret);
			goto out_fail;
		}
		*idx = 0;
		len = strtol(idx+1, NULL, 10);
		if (len < 0) {
			pr_error("Bad blob format");
			goto out_fail;
		}
		snprintf(buf, PATH_MAX, "/boot/%s", name);

		pr_info("Writing file '%s'\n", name);
		ret = named_file_write(buf, prog, len, 0, 0);
		if (ret < 0) {
			pr_error("Couldn't write %s %d\n",buf,ret);
			goto out_fail;
		}
		ptr += len;
	}
	ret = 0;

out_fail:
	umount(bootptn);
	return ret;
}

void libdbupdate_init(void)
{
	aboot_register_flash_cmd("bootloader", update_droid);
}
