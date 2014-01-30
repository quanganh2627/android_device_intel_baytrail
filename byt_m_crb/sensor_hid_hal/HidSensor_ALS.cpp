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
#include <math.h>
#include <poll.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/select.h>
#include <cutils/log.h>

#include "common.h"
#include "SensorConfig.h"
#include "HidSensor_ALS.h"


struct als_sample{
    unsigned short illum;
} __packed;

const struct sensor_t ALSSensor::sSensorInfo_als = {
    "HID_SENSOR ALS", "Intel", 1, SENSORS_LIGHT_HANDLE, SENSOR_TYPE_LIGHT,
    50000.0f, 1.0f, 0.75f, 0, 0, 0, {}
    ,
};
const int retry_cnt = 10;

ALSSensor::ALSSensor(): SensorIIODev("als", "in_intensity_scale", "in_intensity_offset", "in_intensity_", retry_cnt){
    ALOGV(">>ALSSensor 3D: constructor!");
    mPendingEvent.version = sizeof(sensors_event_t);
    mPendingEvent.sensor = ID_L;
    mPendingEvent.type = SENSOR_TYPE_LIGHT;
    memset(mPendingEvent.data, 0, sizeof(mPendingEvent.data));

    // CDD is silent on ALS requirements.  Fix default at 2Hz pending
    // better numbers from somewhere.
     sample_delay_min_ms = 500;

    ALOGV("<<ALSSensor 3D: constructor!");
}

int ALSSensor::processEvent(unsigned char *raw_data, size_t raw_data_len){
    struct als_sample *sample;

    ALOGV(">>%s", __func__);
    if (IsDeviceInitialized() == false){
        ALOGE("Device was not initialized \n");
        return  - 1;
    } if (raw_data_len < sizeof(struct als_sample)){
        ALOGE("Insufficient length \n");
        return  - 1;
    }
    sample = (struct als_sample*)raw_data;
    mPendingEvent.light = (float)sample->illum;

    ALOGV("ALS %fm/s2\n", mPendingEvent.light);
    ALOGV("<<%s", __func__);
    return 0;
}
