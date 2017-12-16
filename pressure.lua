pressPin = 1
gpio.mode(pressPin,gpio.INPUT)
tmr.start(0, 1000, function()
    press =adc.read(pressPin)
delta = 3000000/4096
press = press*delta*2
press = press/4413
    print("Pressure"..press-50)
end)

