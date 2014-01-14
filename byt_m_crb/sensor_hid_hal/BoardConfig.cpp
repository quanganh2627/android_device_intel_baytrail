/*
 * Copyright (C) 2008 The Android Open Source Project
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

#include <fcntl.h>
#include <errno.h>
#include <cutils/log.h>
#include <unistd.h>
#include <cutils/properties.h>

#include "common.h"

#include "BoardConfig.h"
#include "SensorConfig.h"
#include "HidSensor_Accel3D.h"
#include "HidSensor_Gyro3D.h"
#include "HidSensor_Compass3D.h"
#include "HidSensor_ALS.h"

static const struct sensor_t sSensorList[] = {
    AccelSensor::sSensorInfo_accel3D,
    GyroSensor::sSensorInfo_gyro3D,
    CompassSensor::sSensorInfo_compass3D,
    ALSSensor::sSensorInfo_als,
};

const struct sensor_t* BoardConfig::sensorList()
{
    return sSensorList;
}

int BoardConfig::sensorListSize()
{
    int num_files(0);
    DIR *dp(0);
    struct dirent *dirp(0);
    char *key = "persist.sys.sensors.iio.present";
    char value[PROPERTY_VALUE_MAX];

    if (property_get(key, value, "")) {
        if (strncmp(value, "1", 1) == 0) {
            ALOGI("IIO sensor hub detected previously; assuming it is still attached.");
            return ARRAY_SIZE(sSensorList);
        } else {
            ALOGI("IIO sensor hub not detected previously; assuming it still is not attached.");
            return 0;
        }
    }

    for (int i=0; i<250; i++) {
        num_files = 0;
        if ((dp = opendir("/sys/bus/iio/devices")) == NULL){
            usleep(20000);
            continue;
        }
        while ((dirp = readdir(dp)) != NULL){
            num_files++;
        }
        closedir(dp);

        if (num_files <= 2) {
            usleep(20000);
            continue;
        }
        ALOGI("Found IIO sensor hub.");
        if (property_set(key, "1") != 0) {
            ALOGE("Failed to set %s", key);
        }
        return ARRAY_SIZE(sSensorList);
    }

    ALOGI("Didn't find IIO sensor hub.");
    if (property_set(key, "0") != 0) {
        ALOGE("Failed to set %s", key);
    }
    return 0;
}

void BoardConfig::initSensors(SensorBase* sensors[])
{
    sensors[accel] = new AccelSensor();
    sensors[gyro] = new GyroSensor();
    sensors[compass] = new CompassSensor();
    sensors[light] = new ALSSensor();
}

int BoardConfig::handleToDriver(int handle)
{
    switch (handle) {
    case ID_A:
        return accel;
    case ID_M:
        return compass;
    case ID_PR:
    case ID_T:
        return -EINVAL;
    case ID_GY:
        return gyro;
    case ID_L:
        return light;
  default:
        return -EINVAL;
    }
    return -EINVAL;
}
