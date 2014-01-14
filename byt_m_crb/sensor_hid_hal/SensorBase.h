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

#ifndef ANDROID_SENSOR_BASE_H
#define ANDROID_SENSOR_BASE_H

#include <string>

#include <stdint.h>
#include <errno.h>
#include <sys/cdefs.h>
#include <sys/types.h>
#include <hardware/sensors.h>

#include "InputEventReader.h"

struct sensors_event_t;

/**
 * The base class defines how it's supposed to be used by sensors.cpp.
 * Never use this class directly for sensor implementations. A new
 * Sensor<DevType>Dev class must be created.
 *
 * This class does opening & closing of mDevPath which is supposed to be
 * set in the constructor. Open happens on enable(1) & close on enable(0).
 *
 * The sensor is closed & disabled when mFd is -1;
 *
 * Sensor implementations/Sensor<Type>Dev classes must set mPendingEvent
 * flag to true/false by themselves in the readEvent loop.
 */
class SensorBase {

protected:
    std::string mDevPath;
    int mFd;
    bool mHasPendingEvent;
    bool mEnabled;
    sensors_event_t mPendingEvent;

    static int64_t getTimestamp();
    static int64_t timevalToNano(timeval const& t) {
        return t.tv_sec*1000000000LL + t.tv_usec*1000;
    }

    virtual int setInitialState() { return 0; };

public:
    SensorBase():
        mFd(-1),
        mHasPendingEvent(false),
        mEnabled(false) {};

    SensorBase(std::string dev_path):
        mDevPath(dev_path),
        mFd(-1),
        mHasPendingEvent(false),
        mEnabled(false) {};

    virtual ~SensorBase() { close(); };
    virtual int open();
    virtual void close();
    virtual int enable(int enabled) = 0;

    virtual int readEvents(sensors_event_t *data, int count) = 0;
    virtual int setDelay(int64_t ns) = 0;
    virtual int discover() { return 0; }

    int fd() const { return mFd; };
    virtual bool hasPendingEvents() const { return mHasPendingEvent; };
};
#endif  // ANDROID_SENSOR_BASE_H
