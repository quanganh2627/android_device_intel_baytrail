/*
 * Copyright (C) 2010-2012 Intel Corporation
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

#ifndef ANDROID_SENSOR_INPUT_DEV_H
#define ANDROID_SENSOR_INPUT_DEV_H

#include <string>

#include "SensorBase.h"

/**
 * Input device based sensors must inherit this class.
 * The readEvents loop is already defined by this base class,
 * inheritors need to define only processEvent for doing sensor-specific
 * event computations.
 */
class SensorInputDev: public SensorBase {

protected:
    InputEventCircularReader mInputReader;

    bool findInputDev(const std::string &inputName,
                      std::string &foundPath);
    virtual int processEvent(struct input_event const &ev) = 0;

public:
    SensorInputDev(std::string);

    virtual int readEvents(sensors_event_t *data, int count);
};
#endif
