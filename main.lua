dofile("pump.lua")
airPump = Pump:new(16);
waterPump = Pump:new(15);

dofile("led.lua");
dofile("pressure.lua")

timers = {
    main = 1,
    pressure = 2
}

RED = 2;
GREEN = 4;
BLUE = 1;

LEVEL_STOP_PIN = 7;
INSTALL_PIN = 2;
FLOW_PIN = 14;
DISTANCE_PIN_LOW = 12;
DISTANCE_PIN_HIGH = 13;
STOPED_BY_BOTTLE_LEVEL = 1

status = false
flowData = 0;
flowResetCounter = 0;
state = {
    high = 1,
    low = 1,
    isPumping = false
}


MIN_WATER_LEVEL = 15

gpio.mode(DISTANCE_PIN_LOW, gpio.INPUT)
gpio.mode(DISTANCE_PIN_HIGH, gpio.INPUT)
gpio.mode(INSTALL_PIN, gpio.INPUT)
gpio.mode(LEVEL_STOP_PIN, gpio.INPUT)

Pressure:init({
    pin = 1,
    pump = airPump,
    timerId = timers.pressure
})

--MAIN LOOP
tmr.start(timers.main, 500, function()
    --    Read all sensors
    state.high = gpio.read(DISTANCE_PIN_HIGH);
    state.low = gpio.read(DISTANCE_PIN_LOW);

    local levelStatus = gpio.read(LEVEL_STOP_PIN);
    local installStatus = gpio.read(INSTALL_PIN);

    print("levelStatus == 1 " .. tostring(levelStatus == 1))
    print("installStatus == 0 " .. tostring(installStatus == 0))
    if ((levelStatus == 1) and (installStatus == 0)) then
        setColors(GREEN, BLUE, BLUE);
    else
        setColors(GREEN, RED, RED);
        waterPump:turnOff("emergency off");
        applyColors();
        print("return  ")
        return false;
    end
    print("waterPump:isPumping() " .. tostring(waterPump:isPumping()))
    if waterPump:isPumping() then
        setColors(-1, GREEN, -1);
        if state.high == 1 then
            waterPump:turnOff("water is high");

        elseif flowData == 0 then
            print("flowData is 0")
            -- possibly bottle is empty let"s check
            if Pressure:levelNow() < MIN_WATER_LEVEL then
                waterPump:turnOff("pressure is low");
                Pressure:measureLevel();
                setColors(-1, BLUE, -1);
            end
        end
    else

        print("state.low == 1 " .. tostring(state.low == 1))
        print("Pressure:levelNow() > MIN_WATER_LEVEL " .. tostring(Pressure:levelNow()) .. " > " .. tostring(MIN_WATER_LEVEL))

        local bottleIsFull = Pressure:levelNow() > MIN_WATER_LEVEL

        if bottleIsFull then
            if state.low == 1 then
                waterPump:turnOn("water is low");
                setColors(-1, GREEN, -1);
            end;
        else
            Pressure:measureLevel();
            setColors(-1, RED, -1);
        end
    end

    flowResetCounter = flowResetCounter + 1;
    if flowResetCounter == 10 then
        flowData = 0;
        flowResetCounter = 0;
    end

    applyColors();
end)


gpio.mode(FLOW_PIN, gpio.INT, "rising", function()
    flowData = 1
end)