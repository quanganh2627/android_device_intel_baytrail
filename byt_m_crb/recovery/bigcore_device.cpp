/*
 * Copyright (C) 2009 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <linux/input.h>
#include <cutils/android_reboot.h>
#if (MIN_BATTERY_LEVEL > 0)
#include <charger/charger.h>
#endif

#include "common.h"
#include "device.h"
#include "screen_ui.h"

#define MSEC_PER_SEC            (1000LL)
#define BATTERY_UNKNOWN_TIME    (2 * MSEC_PER_SEC)
#define POWER_ON_KEY_TIME       (2 * MSEC_PER_SEC)
#define UNPLUGGED_SHUTDOWN_TIME (30 * MSEC_PER_SEC)
#define CAPACITY_POLL_INTERVAL  (30 * MSEC_PER_SEC)

static const char* HEADERS[] = { "Volume up/down or Arrow up/down to move highlight;",
                                 "power button or Enter key to select.",
                                 "",
                                 NULL };

static const char* ITEMS[] =  {"reboot system now",
                               "apply update from ADB",
                               "apply update from SD Card",
                               "wipe data/factory reset",
                               "wipe cache partition",
                               NULL };

class DefaultUI : public ScreenRecoveryUI {
  public:
    DefaultUI() {
#if (MIN_BATTERY_LEVEL > 0)
        LOGI("Verifying battery level >= %d%% before continuing\n",
                MIN_BATTERY_LEVEL);
        gr_init();

        switch (charger_run(MIN_BATTERY_LEVEL, POWER_ON_KEY_TIME,
                    BATTERY_UNKNOWN_TIME,
                    UNPLUGGED_SHUTDOWN_TIME,
                    CAPACITY_POLL_INTERVAL)) {
        case CHARGER_SHUTDOWN:
            android_reboot(ANDROID_RB_POWEROFF, 0, 0);
            break;
        case CHARGER_PROCEED:
            LOGI("Battery level is acceptable\n");
            break;
        default:
            LOGE("mysterious return value from charger_run()\n");
        }
        gr_exit();
#endif
    }

    virtual KeyAction CheckKey(int key) {
        if (((key == KEY_VOLUMEUP) && IsKeyPressed(KEY_VOLUMEDOWN))
                || ((key == KEY_VOLUMEDOWN) && IsKeyPressed(KEY_VOLUMEUP))) {
            return TOGGLE;
        } else if (((key == KEY_UP) && IsKeyPressed(KEY_DOWN))
                || ((key == KEY_DOWN) && IsKeyPressed(KEY_UP))) {
            return TOGGLE;
        }
        return ENQUEUE;
    }
};

class DefaultDevice : public Device {
  public:
    DefaultDevice() :
        ui(new DefaultUI) {
    }

    RecoveryUI* GetUI() { return ui; }

    int HandleMenuKey(int key, int visible) {
        if (visible) {
            switch (key) {
              case KEY_DOWN:
              case KEY_VOLUMEDOWN:
                return kHighlightDown;

              case KEY_UP:
              case KEY_VOLUMEUP:
                return kHighlightUp;

              case KEY_ENTER:
              case KEY_POWER:
                return kInvokeItem;
            }
        }

        return kNoAction;
    }

    BuiltinAction InvokeMenuItem(int menu_position) {
        switch (menu_position) {
          case 0: return REBOOT;
          case 1: return APPLY_ADB_SIDELOAD;
          case 2: return APPLY_EXT;
          case 3: return WIPE_DATA;
          case 4: return WIPE_CACHE;
          default: return NO_ACTION;
        }
    }

    const char* const* GetMenuHeaders() { return HEADERS; }
    const char* const* GetMenuItems() { return ITEMS; }

  private:
    RecoveryUI* ui;
};

Device* make_device() {
    return new DefaultDevice();
}
