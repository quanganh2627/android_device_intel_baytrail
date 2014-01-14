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
#include "HidSensor_Gyro3D.h"

#define CHANNEL_X 0
#define CHANNEL_Y 1
#define CHANNEL_Z 2

struct gyro_3d_sample{
    unsigned int gyro_x;
    unsigned int gyro_y;
    unsigned int gyro_z;
} __packed;

const struct sensor_t GyroSensor::sSensorInfo_gyro3D = {
    "HID_SENSOR Gyro 3D", "Intel", 1, SENSORS_GYROSCOPE_HANDLE,
        SENSOR_TYPE_GYROSCOPE, RANGE_GYRO, RESOLUTION_GYRO, 6.10f, 0
};
const int HID_USAGE_SENSOR_UNITS_DEGREES_PER_SECOND = 0x15;
const int HID_USAGE_SENSOR_UNITS_RADIANS_PER_SECOND = 0xF012;
const int retry_cnt = 10;

GyroSensor::GyroSensor(): SensorIIODev("gyro_3d", "in_anglvel_scale", "in_anglvel_offset", "in_anglvel_", retry_cnt){
    ALOGV("GyroSensor: constructor\n");
    mPendingEvent.version = sizeof(sensors_event_t);
    mPendingEvent.sensor = ID_GY;
    mPendingEvent.type = SENSOR_TYPE_GYROSCOPE;
    memset(mPendingEvent.data, 0, sizeof(mPendingEvent.data));

    // CDD requires 200Hz (!), but HSB caps out at ~62Hz.  Use that as
    // default.
    sample_delay_min_ms = 16;
}

int GyroSensor::processEvent(unsigned char *raw_data, size_t raw_data_len){
    struct gyro_3d_sample *sample;

    ALOGE(">>%s", __func__);
    if (IsDeviceInitialized() == false){
        ALOGE("Device was not initialized \n");
        return  - 1;
    } if (raw_data_len < sizeof(struct gyro_3d_sample)){
        ALOGE("Insufficient length \n");
        return  - 1;
    }
    sample = (struct gyro_3d_sample*)raw_data;
    if (GetUnitValue() == HID_USAGE_SENSOR_UNITS_DEGREES_PER_SECOND){
        mPendingEvent.data[0] = mPendingEvent.gyro.x = CONVERT_G_D_VTF16E14_X
            (GetChannelBytesUsedSize(CHANNEL_X), GetExponentValue(), sample->gyro_x)
            ;
        mPendingEvent.data[1] = mPendingEvent.gyro.y = CONVERT_G_D_VTF16E14_Y
            (GetChannelBytesUsedSize(CHANNEL_Y), GetExponentValue(), sample->gyro_y)
            ;
        mPendingEvent.data[2] = mPendingEvent.gyro.z = CONVERT_G_D_VTF16E14_Z
            (GetChannelBytesUsedSize(CHANNEL_Z), GetExponentValue(), sample->gyro_z)
            ;
    }
    else if (GetUnitValue() == HID_USAGE_SENSOR_UNITS_RADIANS_PER_SECOND){
        mPendingEvent.data[0] = mPendingEvent.gyro.x = CONVERT_FROM_VTF16
            (GetChannelBytesUsedSize(CHANNEL_X), GetExponentValue(), sample->gyro_x)
            ;
        mPendingEvent.data[1] = mPendingEvent.gyro.y = CONVERT_FROM_VTF16
            (GetChannelBytesUsedSize(CHANNEL_Y), GetExponentValue(), sample->gyro_y)
            ;
        mPendingEvent.data[2] = mPendingEvent.gyro.z = CONVERT_FROM_VTF16
            (GetChannelBytesUsedSize(CHANNEL_Z), GetExponentValue(), sample->gyro_z)
            ;
    }
    else{
        ALOGE("Gyro Unit is not supported");
    }

    ALOGV("GYRO 3D Sample %fm/s2 %fm/s2 %fm/s2\n", mPendingEvent.gyro.x,
        mPendingEvent.gyro.y, mPendingEvent.gyro.z);
    ALOGV("<<%s", __func__);
    return 0;
}
