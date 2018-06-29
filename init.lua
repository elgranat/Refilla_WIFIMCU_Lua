gpio.mode(16, gpio.OUTPUT)
gpio.write(16, gpio.LOW)
gpio.mode(15, gpio.OUTPUT)
gpio.write(15, gpio.LOW)

tmr.start(9, 5000, function()
    dofile("main.lua");
    tmr.stop(9)
end)



