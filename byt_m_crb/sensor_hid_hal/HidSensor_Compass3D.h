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

#ifndef HIDSENSOR_COMPASS3D_H
#define HIDSENSOR_COMPASS3D_H

#include <stdint.h>
#include <errno.h>
#include <sys/cdefs.h>
#include <sys/types.h>

#include "SensorIIODev.h"
#include "Helpers.h"

class CompassSensor : public SensorIIODev {

public:
    CompassSensor();
    virtual int processEvent(unsigned char *raw_data, size_t raw_data_len);
    static const struct sensor_t sSensorInfo_compass3D;
};
#endif
