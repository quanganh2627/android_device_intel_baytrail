#include <droidboot_util.h>
#include <droidboot_plugin.h>
#include <stdlib.h>

static int start_adbd(int argc, char **argv)
{
    if (system("adbd &"))
        die();

    return 0;
}

void libdbadbd_init(void)
{
    if (aboot_register_oem_cmd("adbd", start_adbd))
        die();
}
