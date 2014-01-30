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
#include "HidSensor_Accel3D.h"

#define CHANNEL_X 0
#define CHANNEL_Y 1
#define CHANNEL_Z 2

struct accel_3d_sample{
    unsigned int accel_x;
    unsigned int accel_y;
    unsigned int accel_z;
} __packed;

const struct sensor_t AccelSensor::sSensorInfo_accel3D = {
    "HID_SENSOR Accelerometer 3D", "Intel", 1, SENSORS_ACCELERATION_HANDLE,
    SENSOR_TYPE_ACCELEROMETER, RANGE_A, RESOLUTION_A, 0.23f, 100000, 0, 0, {}
};

const long HID_USAGE_SENSOR_UNITS_G = 0x1A;
const long HID_USAGE_SENSOR_UNITS_METERS_PER_SEC_SQRD = (0x11, 0xE0);
const int retry_cnt = 10;

AccelSensor::AccelSensor(): SensorIIODev("accel_3d", "in_accel_scale", "in_accel_offset", "in_accel_", retry_cnt){
    ALOGV(">>AccelSensor 3D: constructor!");
    mPendingEvent.version = sizeof(sensors_event_t);
    mPendingEvent.sensor = ID_A;
    mPendingEvent.type = SENSOR_TYPE_ACCELEROMETER;
    memset(mPendingEvent.data, 0, sizeof(mPendingEvent.data));

    // CDD requires 120Hz, but HSB caps out at ~62Hz.  Use that as default.
    sample_delay_min_ms = 16;

    ALOGV("<<AccelSensor 3D: constructor!");
}

int AccelSensor::processEvent(unsigned char *raw_data, size_t raw_data_len){
    struct accel_3d_sample *sample;

    ALOGV(">>%s", __func__);

    if (IsDeviceInitialized() == false){
        ALOGE("Device was not initialized \n");
        return  - 1;
    } if (raw_data_len < sizeof(struct accel_3d_sample)){
        ALOGE("Insufficient length \n");
        return  - 1;
    }

    ALOGV("Accel:%2x:%2x:%2x:%2x:%2x:%2x",  *raw_data, *(raw_data + 1), *
        (raw_data + 2), *(raw_data + 3), *(raw_data + 4), *(raw_data + 5));
    sample = (struct accel_3d_sample*)raw_data;
    mPendingEvent.data[0] = mPendingEvent.acceleration.x =
        CONVERT_A_G_VTF16E14_X(GetChannelBytesUsedSize(CHANNEL_X), GetExponentValue(), sample->accel_x);
    mPendingEvent.data[1] = mPendingEvent.acceleration.y =
        CONVERT_A_G_VTF16E14_Y(GetChannelBytesUsedSize(CHANNEL_Y), GetExponentValue(), sample->accel_y);
    mPendingEvent.data[2] = mPendingEvent.acceleration.z =
        CONVERT_A_G_VTF16E14_Z(GetChannelBytesUsedSize(CHANNEL_Z), GetExponentValue(), sample->accel_z);

    ALOGV("ACCEL 3D Sample %fm/s2 %fm/s2 %fm/s2\n", mPendingEvent.acceleration.x,
        mPendingEvent.acceleration.y, mPendingEvent.acceleration.z);
    ALOGV("<<%s", __func__);
    return 0;
}
