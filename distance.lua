echoPin = 13
trigPin = 12

time_start = 0
time_end = 0
gpio.mode(trigPin, gpio.OUTPUT)


gpio.write(trigPin, gpio.LOW)
gpio.mode(echoPin, gpio.INT, 'falling', function()
    time_end = tmr.stopMicroTimer();
    time_end = (time_end + 12) / 6 - 95
    print('Dist: ' .. time_end)
end)

function measure()
    time_start = 0
    gpio.write(trigPin, gpio.HIGH)
    tmr.delayus(12)
    tmr.startMicroTimer();
    gpio.write(trigPin, gpio.LOW)
end



tmr.start(1, 1000, function()

    measure()
end)

