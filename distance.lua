


Distance = {}

Distance.running = false

---Init service
-- @param pins obj with 'echo' & 'trig' params.

function Distance:init(pins, timerId, interval)
--    local echoPin = 13
--    local trigPin = 12
    gpio.mode(pins.trig, gpio.OUTPUT)
    gpio.mode(pins.echo, gpio.INPUT_PULL_DOWN)
    gpio.write(pins.trig, gpio.LOW)

     if self.running then
        tmr.stop(self.timerId)
     end

    local echoPin = pins.echo
    local trigPin =  pins.trig
    local timeAcc = 0
    local counter = 0
    local lastAvg = 0


    self.timerId = timerId
    self.running = true;

    gpio.mode(echoPin, gpio.INT, 'falling', function()
        local time_end = tmr.stopMicroTimer();
        time_end = (time_end + 12) / 6 - 95
        print('Dist: ' .. time_end)
        if time_end < 500 then
            timeAcc = timeAcc + time_end
            counter = counter + 1
        end
    end)

    local function measure()
        gpio.write(trigPin, gpio.HIGH)
        tmr.delayus(12)
        tmr.startMicroTimer();
        gpio.write(trigPin, gpio.LOW)
    end


    tmr.start(timerId, interval, function()
        if counter == 10 then
            lastAvg = timeAcc / 10
            print('Dist avg: ' .. lastAvg)
            counter = 0
            timeAcc = 0
        end
        measure();
    end)

    function Distance:getLastAvg()
        return lastAvg
    end

end;






