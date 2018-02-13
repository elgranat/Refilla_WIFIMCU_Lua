dofile('pump.lua')
waterPump = Pump:new(15);
airPump = Pump:new(16);

dofile('led.lua')

timers = {
    main = 1,
    pressure = 2,
    dist = 3,
    levels = 4,
    waitingWater = 5
}

levelStopPin = 7;
INSTALL_PIN = 2;
FLOW_PIN = 14;

STOPED_BY_BOTTLE_LEVEL = 1

minWaterLevel = 15

levelStatus = 0
installStatus = 1

function emergencyStop(reason)
    print("Emergency stop")
    tmr.stop(timers.main);
    waterPump:turnOff();
    airPump:turnOff();

    if reason == STOPED_BY_BOTTLE_LEVEL then
        setColors(nil, nil, red);
        print("Emergency STOPED_BY_BOTTLE_LEVEL")
        tmr.start(timers.waitingWater, 250, function()
            print("STOPED_BY_BOTTLE_LEVEL now is " .. Pressure:levelNow())
            if Pressure:levelNow() > 50 then
                tmr.stop(timers.waitingWater)
                startRefilla();
            end
        end)
    else --stopped by trigger it will start on interuption
        tmr.stop(timers.waitingWater)
    end
end

function startRefilla()
    flowData = 0;

    local function lowWaterCallback(level)
        print("startRefilla bottle level is " .. level)
        setColors(nil, nil, 0);
        if level < minWaterLevel then
            emergencyStop(STOPED_BY_BOTTLE_LEVEL)
        end
    end

    tmr.start(timers.main, 3000, function()
        print("startRefilla timer start")
        local lastLevel = Distance:getLastAvg();
        if waterPump:isPumping() then
            print("startRefilla pumping")
            if lastLevel < 35 then
                print("startRefilla last dist is " .. lastLevel .. " turnOFF")
                waterPump:turnOff();
            end

            if flowData == 0 then
                -- possibly bottle is empty let's check
                setColors(nil, nil, blue);
                Pressure:measureLevel(lowWaterCallback);
            end
        else
            if lastLevel > 55 then
                print("startRefilla last dist is " .. lastLevel .. " turnOn")
                waterPump:turnOn();
            end
        end
        setColors(nil, nil, blue);
        flowData = 0;
    end)

    Pressure:measureLevel(lowWaterCallback);
end


function processInstallSwitch()
    tmr.stop(timers.levels);
    levelStatus = gpio.read(levelStopPin)
    installStatus = gpio.read(INSTALL_PIN)

    local led1 = green;
    local led2 = green;
    if levelStatus == 1 and installStatus == 0 then
        startRefilla();
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

gpio.mode(levelStopPin, gpio.INT, 'both', function()
    tmr.stop(timers.levels);
    print("levelStopPin interupt ")
    tmr.start(timers.levels, 100, processInstallSwitch)
end)

gpio.mode(INSTALL_PIN, gpio.INT, 'both', function()
    tmr.stop(timers.levels);
    print("INSTALL_PIN interupt ")
    tmr.start(timers.levels, 100, processInstallSwitch)
end)

--function hasWater

dofile('distance.lua')

Distance:init({ echo = 13, trig = 12 }, timers.dist, 250);

dofile('pressure.lua')

Pressure:init({
    pin = 1,
    pump = airPump,
    timerId = timers.pressure
})

gpio.mode(FLOW_PIN, gpio.INT, 'rising', function() flowData = 1 end)

