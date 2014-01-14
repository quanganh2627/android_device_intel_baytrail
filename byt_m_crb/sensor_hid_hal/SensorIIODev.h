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

#ifndef ANDROID_SENSOR_IIO_DEV_H
#define ANDROID_SENSOR_IIO_DEV_H

#include <iostream>
#include <string>
#include <cstring>
#include <string>
#include <sstream>
#include <iostream>
#include <fstream>
#include <vector>
#include <fcntl.h>
#include <unistd.h>
#include <stdarg.h>
#include <poll.h>
#include <dirent.h>
#include <errno.h>
#include "SensorBase.h"
#include "Helpers.h"

// Used by SensorIIO device containers
struct SensorIIOChannel{
    std::string name;
    float scale;
    float offset;
    unsigned index;
    unsigned real_bytes;
    unsigned bytes;
    unsigned shift;
    unsigned mask;
    unsigned is_signed;
    unsigned enabled;
};

/**
 * Input device based sensors must inherit this class.
 * The readEvents loop is already defined by this base class,
 * inheritors need to define only processEvent for doing sensor-specific
 * event computations.
 */
class SensorIIODev: public SensorBase{

private:
    bool initialized;
    int device_number;
    std::stringstream dev_device_name;
    std::stringstream scan_el_dir;
    std::stringstream buffer_dir_name;
    std::vector < SensorIIOChannel > info_array;
    int num_channels;
    int buffer_len;
    int enable_buffer;
    int file_id;
    int datum_size;
    std::string unit_expo_str;
    std::string unit_str;
    std::string device_name;
    std::string channel_prefix_str;
    long unit_expo_value;
    long units_value;
    int retry_count;
    unsigned char *raw_buffer;

    int discover();
    int EnableIIODevice();
    int GetDir(const std::string& dir, std::vector < std::string >& files);
    void ListFiles(const std::string& dir);
    int FindDeviceNumberFromName(const std::string& name, const std::string& prefix);

    int BuildChannelList();
    int SetUpTrigger(int dev_num);
    int SetUpBufferLen(int len);
    int GetSizeFromChannels();
    int ParseIIODirectory(const std::string& name);
    int EnableChannels();
    int AllocateRxBuffer();
    int FreeRxBuffer();

protected:

    // Subclasses (e.g. HID devices) may implement "non-streaming"
    // sensors with a non-constant sample rate, leveraging a
    // microcontroller "sensor hub" to do the sampling and interrupt
    // the CPU only on change.  Google allows this in the api by
    // setting minDelay to 0 in sensor_t.  But if we do that, the
    // framework has no idea what values can be set so often tries
    // implausibly high values for "game" mode.  Setting this to
    // non-zero allows the subclasses to clamp to device-specific
    // values.
    int sample_delay_min_ms;

    bool IsDeviceInitialized();
    int GetDeviceNumber();
    int SetDataReadyTrigger(int dev_num, bool status);
    int EnableBuffer(int status);
    int SetSampleDelay(int dev_num, int rate);
    int DeviceActivate(int dev_num, int state);
    int DeviceSetSensitivity(int dev_num, int value);
    long GetUnitValue();
    long GetExponentValue();
    int ReadHIDMeasurmentUnit(long *unit);
    int ReadHIDExponentValue(long *exponent);
    int GetChannelBytesUsedSize(unsigned int channel_no);
    virtual int processEvent(unsigned char *raw_data, size_t raw_data_len)
        = 0;
    virtual int readEvents(sensors_event_t *data, int count);
    virtual int enable(int enabled);
    virtual int setDelay(int64_t delay_ns);
    virtual int setInitialState();

public:
    SensorIIODev(const std::string& dev_name, const std::string& units, const std::string& exponent, const std::string& channel_prefix);
    SensorIIODev(const std::string& dev_name, const std::string& units, const std::string& exponent, const std::string& channel_prefix, int retry_cnt);

};
#endif
