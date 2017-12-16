print('---WiFiMCU Demo---')

print('Flash LED')

stbPin = 6
dataPin = 5
clockPin = 4
regCell = 0
mode = gpio.HIGH;

gpio.mode(dataPin, gpio.OUTPUT_OPEN_DRAIN_PULL_UP)
gpio.mode(clockPin, gpio.OUTPUT_OPEN_DRAIN_PULL_UP)
gpio.mode(stbPin, gpio.OUTPUT_OPEN_DRAIN_PULL_UP)

gpio.write(dataPin, gpio.LOW)
gpio.write(clockPin, gpio.LOW)
gpio.write(stbPin, gpio.LOW)

for i = 1, 8 do
    gpio.write(dataPin, mode)
    tmr.delayms(10)
    gpio.write(clockPin, gpio.HIGH)
    tmr.delayms(10)
    gpio.write(clockPin, gpio.LOW)
end


gpio.write(stbPin, gpio.HIGH)
tmr.delayms(10)
gpio.write(stbPin, gpio.LOW)


