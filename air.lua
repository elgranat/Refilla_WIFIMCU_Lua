

airPin = 16


gpio.mode(airPin, gpio.OUTPUT)

gpio.write(airPin, gpio.LOW)


tmr.start(1, 1000, function()
    gpio.write(airPin, gpio.HIGH)
    tmr.delayms(300)
    gpio.write(airPin, gpio.LOW)
end)