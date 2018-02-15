Pressure = { running = false }

function Pressure:init(config)
    self.pressPin = config.pin
    self.pump = config.pump
    self.tmrId = config.timerId
    gpio.mode(config.pin , gpio.INPUT)
end

function Pressure:levelNow()
    local press = adc.read(self.pressPin)
    local delta = 3000000 / 4096
    press = press * delta * 2
    press = (press / 4413) - 50

    return press;
end

function Pressure:measureLevel(callback)
    local last = 100000;
    local diff;
    self.pump:turnOn("measure pressure");
    tmr.start(self.tmrId, 250, function()
        local press = self:levelNow()
        diff = last - press
        last = press
        if (diff < 6) then
            tmr.stop(self.tmrId)
            self.pump:turnOff("measure pressure end at " .. press);
            last = 10000
            tmr.start(self.tmrId, 100, function()
                local press = self:levelNow()
                diff = last - press
                last = press
                if (diff < 6) then
                    tmr.stop(self.tmrId)
                    callback(last)
                end
            end)
        end
    end)
end

