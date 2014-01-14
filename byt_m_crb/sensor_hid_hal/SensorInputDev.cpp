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
#include <dirent.h>
#include <fcntl.h>
#include <linux/input.h>
#include <cutils/log.h>

#include "SensorInputDev.h"

SensorInputDev::SensorInputDev(std::string dev)
    : SensorBase(),
    mInputReader(4)
{
    findInputDev(dev, mDevPath);
}

int SensorInputDev::readEvents(sensors_event_t* data, int count)
{
    if (count < 1)
        return -EINVAL;

    if (mHasPendingEvent) {
        mHasPendingEvent = false;
        mPendingEvent.timestamp = getTimestamp();
        *data = mPendingEvent;
        return 1;
    }

    if (mFd < 0)
        return -EBADF;

    ssize_t n = mInputReader.fill(mFd);
    if (n < 0)
        return n;

    int numEventReceived = 0;
    input_event const* event;

#if FETCH_FULL_EVENT_BEFORE_RETURN
again:
#endif
    while (count && mInputReader.readEvent(&event)) {
        /* do sensor specific stuff */
        processEvent(*event);

        if (event->type == EV_SYN) {
            mPendingEvent.timestamp = timevalToNano(event->time);
            if (mEnabled) {
                *data++ = mPendingEvent;
                count--;
                numEventReceived++;
            }
            ALOGV("%s:%s:, in type = EV_SYN, after, count = %d, numEventReceived = %d, mEnabled = %d",
                 __func__, mDevPath.c_str(), count, numEventReceived, mEnabled);
        }

        mInputReader.next();
    }

#if FETCH_FULL_EVENT_BEFORE_RETURN
    /* if we didn't read a complete event, see if we can fill and
       try again instead of returning with nothing and redoing poll. */
    if (numEventReceived == 0 && mEnabled == 1) {
        n = mInputReader.fill(mFd);
        if (n)
            goto again;
    }
#endif

    return numEventReceived;
}

bool SensorInputDev::findInputDev(const std::string &inputName,
                                  std::string &foundPath)
{
    bool found = false;
    std::string dev = "/dev/input";
    DIR *dir = opendir(dev.c_str());
    if (!dir)
        return false;

    struct dirent *de;
    while ((de = readdir(dir))) {
        if(de->d_name[0] == '.' &&
           (de->d_name[1] == '\0' ||
            (de->d_name[1] == '.' && de->d_name[2] == '\0')))
            continue;

        int fd = ::open((dev + "/" + de->d_name).c_str(), O_RDONLY);
        if (fd < 0)
            continue;

        ALOGV("%s: probing path %s against %s", __func__, (dev + "/" + de->d_name).c_str(), inputName.c_str());
        char readName[80];
        if (ioctl(fd, EVIOCGNAME(sizeof(readName) - 1), &readName) < 1)
                readName[0] = '\0';

        ::close(fd);

        if (inputName.compare(readName) == 0) {
            foundPath = (dev + "/" + de->d_name);
            found = true;
            ALOGV("%s: found %s", __func__, foundPath.c_str());
            break;
        }
    }

    closedir(dir);

    ALOGE_IF(!found, "couldn't find '%s' input device", inputName.c_str());

    return found;
}
