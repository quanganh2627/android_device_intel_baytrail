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

#ifndef BOARD_CONFIG_H
#define BOARD_CONFIG_H

struct sensors_poll_context_t;
class SensorBase;

/* implementations are located in board specific dirs */
class BoardConfig {

public:
    static const struct sensor_t* sensorList();
    static int sensorListSize();

private:
    static int handleToDriver(int handle);
    static void initSensors(SensorBase* sensors[]);

    friend struct sensors_poll_context_t;
};

#endif
