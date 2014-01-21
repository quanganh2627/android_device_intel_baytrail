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
#include "HidSensor_Pressure.h"

#define CHANNEL_PR 0

/* TODO: POWERCONSUMP_PRESS, PRESS_MINDELAY replace or fill that macros */
#define POWERCONSUMP_PRESS 	0.11f
#define PRESS_MINDELAY		40000
#define RANGE_PRESS		    1260
#define RESOLUTION_PRESS	0.0f

struct pressure_sample{
    unsigned int pressure_s; /* TODO: check type: too short? */
} __packed;

const struct sensor_t PressureSensor::sSensorInfo_pressure = {
    "HID_SENSOR Barometer Sensor", "STMicroelectronics", 1, SENSORS_PRESSURE_HANDLE,
        SENSOR_TYPE_PRESSURE, RANGE_PRESS, RESOLUTION_PRESS, POWERCONSUMP_PRESS, PRESS_MINDELAY,
};

const long HID_USAGE_SENSOR_UNITS_PASCAL = 0xF1E1;
const long UNIT_EXPO_DEC_BASE = 0x0F;  /* TODO: ? */
const int retry_cnt = 5;

PressureSensor::PressureSensor(): SensorIIODev("pressure", "in_pressure_scale", "in_pressure_offset", "in_pressure_", retry_cnt){
    ALOGV(">>PressureSensor: constructor!");
    mPendingEvent.version = sizeof(sensors_event_t);
    mPendingEvent.sensor = ID_PR; /* TODO: check macro in sensorList*/
    mPendingEvent.type = SENSOR_TYPE_PRESSURE;
    memset(mPendingEvent.data, 0, sizeof(mPendingEvent.data));
    ALOGV("<<PressureSensor: constructor!");
}

int PressureSensor::processEvent(unsigned char *raw_data, size_t raw_data_len){
    struct pressure_sample *sample;

    ALOGV(">>%s", __func__);

    if (IsDeviceInitialized() == false){
        ALOGE("Device was not initialized \n");
        return  - 1;
    } if (raw_data_len < sizeof(struct pressure_sample)){
        ALOGE("Insufficient length \n");
        return  - 1;
    }

    sample = (struct pressure_sample*) raw_data;
    ALOGV("Pressure:%2x",  sample->pressure_s);

   /* TODO: following  is just a work arount unit conversion is needed */
   //mPendingEvent.data[0] = mPendingEvent.pressure = (1.0/1000.0f)*(float)sample->pressure_s; /* (1.0/1000.0f) */

	mPendingEvent.data[0] = mPendingEvent.pressure =
		CONVERT_PR_HPA_VTF16E14(GetChannelBytesUsedSize(CHANNEL_PR), GetExponentValue(), sample->pressure_s);

    ALOGV("PRESSURE Sample %f(hPa=Pa/100)\n", mPendingEvent.pressure);
    ALOGV("<<%s", __func__);
    return 0;
}
