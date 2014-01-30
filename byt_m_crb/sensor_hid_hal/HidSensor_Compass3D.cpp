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
#include "HidSensor_Compass3D.h"

#define CHANNEL_X 0
#define CHANNEL_Y 1
#define CHANNEL_Z 2

struct compass_3d_sample{
    unsigned int compass_x;
    unsigned int compass_y;
    unsigned int compass_z;
} __packed;

const struct sensor_t CompassSensor::sSensorInfo_compass3D = {
    "HID_SENSOR Compass 3D", "Intel", 1, SENSORS_MAGNETIC_FIELD_HANDLE,
    SENSOR_TYPE_MAGNETIC_FIELD, RANGE_M, RESOLUTION_M, 0.1f, 1000000, 0, 0, {}
};
const int retry_cnt = 10;

CompassSensor::CompassSensor(): SensorIIODev("magn_3d", "in_magn_scale", "in_magn_offset", "in_magn_", retry_cnt){
    ALOGV(">>ComassSensor 3D: constructor!");
    mPendingEvent.version = sizeof(sensors_event_t);
    mPendingEvent.sensor = ID_M;
    mPendingEvent.type = SENSOR_TYPE_MAGNETIC_FIELD;
    memset(mPendingEvent.data, 0, sizeof(mPendingEvent.data));

    // CDD 4.2 requires 10Hz.  20Hz is the maximum for HSB.
    sample_delay_min_ms = 50;

    ALOGV("<<ComassSensor 3D: constructor!");
}

int CompassSensor::processEvent(unsigned char *raw_data, size_t raw_data_len){
    struct compass_3d_sample *sample;

    ALOGV(">>%s", __func__);
    if (IsDeviceInitialized() == false){
        ALOGE("Device was not initialized \n");
        return  - 1;
    } if (raw_data_len < sizeof(struct compass_3d_sample)){
        ALOGE("Insufficient length \n");
        return  - 1;
    }
    sample = (struct compass_3d_sample*)raw_data;

    mPendingEvent.data[0] = mPendingEvent.magnetic.x = CONVERT_M_MG_VTF16E14_X
        (GetChannelBytesUsedSize(CHANNEL_X), GetExponentValue(), sample->compass_x);
    mPendingEvent.data[1] = mPendingEvent.magnetic.y = CONVERT_M_MG_VTF16E14_Y
        (GetChannelBytesUsedSize(CHANNEL_Y), GetExponentValue(), sample->compass_y);
    mPendingEvent.data[2] = mPendingEvent.magnetic.z = CONVERT_M_MG_VTF16E14_Z
        (GetChannelBytesUsedSize(CHANNEL_Z), GetExponentValue(), sample->compass_z);

    ALOGV("COMPASS 3D Sample %fuT %fuT %fuT\n", mPendingEvent.magnetic.x,
        mPendingEvent.magnetic.y, mPendingEvent.magnetic.z);
    ALOGV("<<%s", __func__);
    return 0;
}
