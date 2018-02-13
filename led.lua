
stbPin = 6
dataPin = 5
clockPin = 4
regCell = 0
mode = gpio.HIGH;

red = 2
green = 4
blue = 1

old = {
    first = 0,
    second = 0,
    third = 0
}

gpio.mode(dataPin, gpio.OUTPUT)
gpio.mode(clockPin, gpio.OUTPUT)
gpio.mode(stbPin, gpio.OUTPUT)

gpio.write(dataPin, gpio.LOW)
gpio.write(clockPin, gpio.LOW)
gpio.write(stbPin, gpio.LOW)

function clock()
    tmr.delayms(1)
    gpio.write(clockPin, gpio.HIGH)
    tmr.delayms(1)
    gpio.write(clockPin, gpio.LOW)
end

function setColors(first, second, third)

    old.first = first or old.first or 0;
    old.second = second or old.second or 0;
    old.third = third or old.third or 0;

    local val = old.first + (old.third * 8) + old.second * 32;

    local b = bit.isset(val,5)
    local a;

    if b then
        a = bit.isset(val,4)
        val = bit.set(val,4)
        else
        a = bit.isset(val,4)
        val = bit.clear(val,4)
    end

    if a then
       val = bit.set(val,5)
    else
       val = bit.clear(val,5)
    end

    for i = 0, 7 do
       local b = bit.isset(val,i)

        if b then
            gpio.write(dataPin, gpio.HIGH)
        else
            gpio.write(dataPin, gpio.LOW)
        end
        clock()
    end

    gpio.write(stbPin, gpio.HIGH)
    tmr.delayms(1)
    gpio.write(stbPin, gpio.LOW)
end







