

waterPin = 15


gpio.mode(waterPin, gpio.OUTPUT)

gpio.write(waterPin, gpio.LOW)


tmr.start(1, 1000, function()
    gpio.write(waterPin, gpio.HIGH)
    tmr.delayms(300)
    gpio.write(waterPin, gpio.LOW)
end)