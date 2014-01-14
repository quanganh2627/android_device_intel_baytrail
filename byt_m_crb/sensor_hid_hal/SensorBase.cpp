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
#include <assert.h>

#include <cutils/log.h>

#include <linux/input.h>

#include "SensorBase.h"

int64_t SensorBase::getTimestamp()
{
    struct timespec t;
    t.tv_sec = t.tv_nsec = 0;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return int64_t(t.tv_sec)*1000000000LL + t.tv_nsec;
}

int SensorBase::open()
{
    if (mDevPath == "") {
        ALOGE("mDevPath is not set");
        return -1;
    }
    mFd = ::open(mDevPath.c_str(), O_RDONLY);
    ALOGE_IF(mFd < 0, "%s: device %s err:%d", __func__, mDevPath.c_str(), -errno);
    ALOGV("%s: device path:%s, fd:%d", __func__, mDevPath.c_str(), mFd);
    return mFd;
}

void SensorBase::close()
{
    int ret = ::close(mFd);
    mFd = -1;
    ALOGV("%s: device path:%s, fd:%d", __func__, mDevPath.c_str(), mFd);
}
