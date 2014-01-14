= How to add/config a new board =

	Look into vendor/intel/<board>/libsensors for inspiration/templates.
BUT don't just copy paste without understanding what you are doing. The idea
is to select the necessary sensors via sensor headers, fill in the sensor list
with each sensor's sSensorInfo, instantiate sensors in initSensors and map id's
in handleToDriver.

= How to add a new Sensor implementation =

	What type of sensor driver are you using?

- Input device? Use SensorInputDev. The advantage of using this class is that
the readEvents loop exists already, only processEvent must be implemented
for that pourpouse. Of course, if you need a special kind of readEvents loop,
it can be re-implemented.

- Basic char device? use SensorCharDev. You are on your own here regarding
readEvent.

- Something else? This means you are using some other type of driver and a
new Sensor<Type>Dev class must be implementad first and then the sensor
implementation must inherit from that.

= Do's & Don'ts =

- For sensor implementations, don't inherit from SensorBase class directly.
- Don't copy paste code without understanding what it does.
- Do use references instead of pointers as much as possible.
- Do use std::string's instead of C strings. It avoids many extra dubious
operations.
- Don't use streams on sysfs entries. Streams can do impartial writes and mess
up the sysfs data.
