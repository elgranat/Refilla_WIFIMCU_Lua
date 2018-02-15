Pump = {}

function Pump:new(pin)

    local obj = {}

    local private = {}

    private.on = false
    private.pin = pin

    gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, gpio.LOW)

    function obj:turnOn(reason)
        print("turnOn pump " .. private.pin .. reason)
        gpio.write(private.pin, gpio.HIGH)
        private.on = true
    end

    function obj:turnOff(reason)
        print("turnOff pump " .. private.pin .. reason)
        gpio.write(private.pin, gpio.LOW)
        private.on = false
    end

    function obj:isPumping()
        return private.on;
    end

    setmetatable(obj, self)
    self.__index = self;
    return obj
end
