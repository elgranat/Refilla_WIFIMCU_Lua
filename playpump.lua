speakerPin = 15

gpio.mode(speakerPin, gpio.OUTPUT)

t = {}
t["c"] = 261
t["d"] = 294
t["e"] = 329
t["f"] = 349
t["g"] = 391
t["gS"] = 415
t["a"] = 440
t["aS"] = 455
t["b"] = 466
t["cH"] = 523
t["cSH"] = 554
t["dH"] = 587
t["dSH"] = 622
t["eH"] = 659
t["fH"] = 698
t["fSH"] = 740
t["gH"] = 784
t["gSH"] = 830
t["aH"] = 880

function beep(pin, tone, duration)
    local freq = t[tone .. ""];
    print("Frequency:" .. freq)
    pwm.start(pin, freq * 5, 50)
    tmr.delayms(duration)

    pwm.stop(pin)

    tmr.wdclr()

    tmr.delayms(1)
end

beep(speakerPin, "a", 500)
beep(speakerPin, "a", 500)

beep(speakerPin, "a", 500)

beep(speakerPin, "f", 350)

beep(speakerPin, "cH", 150)

beep(speakerPin, "a", 500)

beep(speakerPin, "f", 350)



beep(speakerPin, "cH", 150)

beep(speakerPin, "a", 1000)

beep(speakerPin, "eH", 500)



beep(speakerPin, "eH", 500)

beep(speakerPin, "eH", 500)

beep(speakerPin, "fH", 350)

beep(speakerPin, "cH", 150)

beep(speakerPin, "gS", 500)

beep(speakerPin, "f", 350)

beep(speakerPin, "cH", 150)

beep(speakerPin, "a", 1000)

beep(speakerPin, "aH", 500)

beep(speakerPin, "a", 350)

beep(speakerPin, "a", 150)

beep(speakerPin, "aH", 500)

beep(speakerPin, "gSH", 250)

beep(speakerPin, "gH", 250)

beep(speakerPin, "fSH", 125)

beep(speakerPin, "fH", 125)

beep(speakerPin, "fSH", 250)

tmr.delayms(250)

beep(speakerPin, "aS", 250)



beep(speakerPin, "dSH", 500)

beep(speakerPin, "dH", 250)

beep(speakerPin, "cSH", 250)

beep(speakerPin, "cH", 125)

beep(speakerPin, "b", 125)

beep(speakerPin, "cH", 250)

tmr.delayms(250)

beep(speakerPin, "f", 125)

beep(speakerPin, "gS", 500)

beep(speakerPin, "f", 375)

beep(speakerPin, "a", 125)

beep(speakerPin, "cH", 500)

beep(speakerPin, "a", 375)

beep(speakerPin, "cH", 125)

beep(speakerPin, "eH", 1000)

beep(speakerPin, "aH", 500)

beep(speakerPin, "a", 350)



beep(speakerPin, "a", 150)

beep(speakerPin, "aH", 500)

beep(speakerPin, "gSH", 250)

beep(speakerPin, "gH", 250)

beep(speakerPin, "fSH", 125)

beep(speakerPin, "fH", 125)

beep(speakerPin, "fSH", 250)

tmr.delayms(250)

beep(speakerPin, "aS", 250)

beep(speakerPin, "dSH", 500)

beep(speakerPin, "dH", 250)



beep(speakerPin, "cSH", 250)

beep(speakerPin, "cH", 125)

beep(speakerPin, "b", 125)

beep(speakerPin, "cH", 250)

tmr.delayms(250)

beep(speakerPin, "f", 250)

beep(speakerPin, "gS", 500)

beep(speakerPin, "f", 375)

beep(speakerPin, "cH", 125)

beep(speakerPin, "a", 500)

beep(speakerPin, "f", 375)

beep(speakerPin, "c", 125)

beep(speakerPin, "a", 1000)
