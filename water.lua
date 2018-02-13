
waterPump = {
    on = false;
    pin = 0;
}

function waterPump:turnOn()
    gpio.write(self.pin, gpio.HIGH)
    self.on = true
end;
function waterPump:turnOff()
    gpio.write(self.pin, gpio.LOW)
    self.on = false
end;

function waterPump:init(pin)
    self.pin = pin;

end;