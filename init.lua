dofile("pump.lua")
airPump = Pump:new(16);

speakerPin = 15
dofile("playpump.lua")

waterPump = Pump:new(15);
dofile("led.lua")

timers = {
    main = 1,
    pressure = 2,
    dist = 3,
    levels = 4,
    waitingWater = 5
}

LEVEL_STOP_PIN = 7;
INSTALL_PIN = 2;
FLOW_PIN = 14;
DISTANCE_PIN_LOW = 12;
DISTANCE_PIN_HIGH = 13;
STOPED_BY_BOTTLE_LEVEL = 1

status = false
flowData = 0;
low = 1;
high = 0

minWaterLevel = 15

gpio.mode(DISTANCE_PIN_LOW, gpio.INPUT)
gpio.mode(DISTANCE_PIN_HIGH, gpio.INPUT)

function emergencyStop(reason)
    print("Emergency stop")

    status = false
    tmr.stop(timers.main);
    waterPump:turnOff("emergency");
    airPump:turnOff("emergency");

    if reason == STOPED_BY_BOTTLE_LEVEL then
        setColors(nil, nil, red);
        print("Emergency STOPED_BY_BOTTLE_LEVEL")
        tmr.start(timers.waitingWater, 250, function()
            print("STOPED_BY_BOTTLE_LEVEL now is " .. Pressure:levelNow())
            if Pressure:levelNow() > 50 then
                tmr.stop(timers.waitingWater)
                startRefilla("stopped by bottle");
            end
        end)
    else
        --stopped by trigger it will start on interuption
        tmr.stop(timers.waitingWater)
    end
end

function startRefilla(arg)
    status = true

    if arg then
        print("startRefilla func start from" .. arg)
    end

    tmr.start(timers.dist, 500, function()
        high = gpio.read(DISTANCE_PIN_HIGH);
    end)

    tmr.start(timers.main, 3000, function()

        if waterPump:isPumping() then
            if high == 1 then
                waterPump:turnOff("water is high");
            end

            if flowData == 0 then
                print("flowData is 0")
                -- possibly bottle is empty let"s check
                setColors(nil, nil, blue);

                Pressure:measureLevel(function(level)
                    print("startRefilla bottle level is " .. level)
                    setColors(nil, nil, 0);
                    if level < minWaterLevel then
                        emergencyStop(STOPED_BY_BOTTLE_LEVEL)
                    end
                end);
            end
        else
            low = gpio.read(DISTANCE_PIN_LOW);
            if low == 1 then
                --                print("startRefilla last dist is " .. low .. " turnOn")
                waterPump:turnOn("water is low");
            end
        end
        setColors(nil, nil, blue);
        flowData = 0;
    end)

    Pressure:measureLevel(function(level)
        print("startRefilla bottle level is " .. level)
        setColors(nil, nil, 0);
        if level < minWaterLevel then
            emergencyStop(STOPED_BY_BOTTLE_LEVEL)
        end
    end);
end

dofile("pressure.lua")

Pressure:init({
    pin = 1,
    pump = airPump,
    timerId = timers.pressure
})

gpio.mode(LEVEL_STOP_PIN, gpio.INT, "rising", function()
    tmr.stop(timers.levels);
    --    print("LEVEL_STOP_PIN interupt ")
    tmr.start(timers.levels, 20, processInstallSwitch)
end)

gpio.mode(INSTALL_PIN, gpio.INT, "both", function()
    tmr.stop(timers.levels);
    --    print("INSTALL_PIN interupt ")
    tmr.start(timers.levels, 20, processInstallSwitch)
end)

function processInstallSwitch()
    tmr.stop(timers.levels);
    local levelStatus = gpio.read(LEVEL_STOP_PIN)
    local installStatus = gpio.read(INSTALL_PIN)

    local led1 = green;
    local led2 = green;
    if levelStatus == 1 and installStatus == 0 then
        if status == false then startRefilla("install pins") end;
    else
        emergencyStop();
    end

    if levelStatus == 0 then
        led1 = red;
    end

    if installStatus == 1 then
        led2 = red
    end
    setColors(led1, led2);
end

processInstallSwitch();

function flowCallback()
    print("flowData ")
    setColors(blue, blue);
    flowData = 1
end

gpio.mode(FLOW_PIN, gpio.INT, "rising", flowCallback)

