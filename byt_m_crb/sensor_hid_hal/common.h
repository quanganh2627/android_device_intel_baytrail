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

#ifndef ANDROID_SENSORS_COMMON_H
#define ANDROID_SENSORS_COMMON_H

#include <linux/input.h>

#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))

#define ID_A  (0)
#define ID_M  (1)
#define ID_O  (2)
#define ID_L  (3)
#define ID_P  (4)
#define ID_GY (5)
#define ID_PR (6)
#define ID_T  (7)
#define MAX_SENSOR_CNT (ID_T+1)

#define SENSORS_ACCELERATION     (1<<ID_A)
#define SENSORS_MAGNETIC_FIELD   (1<<ID_M)
#define SENSORS_ORIENTATION      (1<<ID_O)
#define SENSORS_LIGHT            (1<<ID_L)
#define SENSORS_PROXIMITY        (1<<ID_P)
#define SENSORS_GYROSCOPE        (1<<ID_GY)
#define SENSORS_PRESSURE         (1<<ID_PR)
#define SENSORS_TEMPERATURE      (1<<ID_T)

#define SENSORS_ACCELERATION_HANDLE     0
#define SENSORS_MAGNETIC_FIELD_HANDLE   1
#define SENSORS_ORIENTATION_HANDLE      2
#define SENSORS_LIGHT_HANDLE            3
#define SENSORS_PROXIMITY_HANDLE        4
#define SENSORS_GYROSCOPE_HANDLE        5
#define SENSORS_PRESSURE_HANDLE         6
#define SENSORS_TEMPERATURE_HANDLE      7

/* The next one is used to set the timeout used for polling the file
 * descriptors.
 */
#define POLL_TIMEOUT_MSEC           3000L

#endif
