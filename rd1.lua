local flash = false
local boot = true
local bootScreenTimeSeconds = 2
local flashScreenTimeSeconds = 0.5
local bigScreensPath = "Asset_154x.png"
local smallScreensPath = "Asset_164x.png"
local backgroundPath = "Asset_155x.png"
local bgColor = rgbm(19/255, 129/255, 108/255, 1)
local currentSelectedScreen = 1
local currentBigScreen = 1
local currentSmallLeftScreen = 1
local currentSmallRightScreen = 2

function displayBootScreen()
    display.image { image = bigScreensPath, pos = vec2(0,0), color = lcdColor, size = vec2(1024,1024), uvStart = vec2(0,0), uvEnd = vec2(1024/1024, 582/2048) }
    setTimeout(function ()
        boot = false
    end, bootScreenTimeSeconds, "boot")
end

local bigScreenPos = { 
    {Start = vec2(4/1024,599/2048), End = vec2(1028/1024, 849/2048)},
    {Start = vec2(4/1024,1274/2048), End = vec2(1028/1024, 1524/2048)},
    Flash = false
}

local smallLeftScreenPos = {
    {Start = vec2(13/1680,7/1404), End = vec2(828/1680,443/1404)},
    {Start = vec2(13/1680,485/1404), End = vec2(828/1680,921/1404)},
    {Start = vec2(13/1680,959/1404), End = vec2(828/1680,1395/1404)},
    Flash = false
}
local smallRightScreenPos = {
    {Start = vec2(923/1680,7/1404), End = vec2(1671/1680,443/1404)},
    {Start = vec2(923/1680,485/1404), End = vec2(1671/1680,921/1404)},
    {Start = vec2(923/1680,959/1404), End = vec2(1671/1680,1395/1404)},
    Flash = false
}

local allScreens = {bigScreenPos, smallLeftScreenPos, smallRightScreenPos}

function handleSelectScreenMode()
    if car.extraD then
        clearTimeout(id)
        allScreens[currentSelectedScreen]["Flash"] = false
        ac.setExtraSwitch(3, false)
        if currentSelectedScreen < 3 then
            currentSelectedScreen = currentSelectedScreen + 1
        else
            currentSelectedScreen = 1
        end
        allScreens[currentSelectedScreen]["Flash"] = true
        id = setTimeout(function ()
            allScreens[currentSelectedScreen]["Flash"] = false
        end, 5, 123)
    end

    if car.extraC and allScreens[currentSelectedScreen]["Flash"] then
        ac.setExtraSwitch(2, false)
        if currentSelectedScreen == 1 then
            if currentBigScreen < 2 then
                currentBigScreen = currentBigScreen + 1
           else
                currentBigScreen = 1
           end
        elseif currentSelectedScreen == 2 then
            if currentSmallLeftScreen < 3 then
                currentSmallLeftScreen = currentSmallLeftScreen + 1
           else
                currentSmallLeftScreen = 1
           end
        elseif currentSelectedScreen == 3 then
            if currentSmallRightScreen < 3 then
                currentSmallRightScreen = currentSmallRightScreen + 1
           else
                currentSmallRightScreen = 1
           end
        end
    end
end

function displayBackground()
    if car.headlightsActive then
        bgColor = rgbm.colors.orange
    else
        bgColor = rgbm(19/255, 129/255, 108/255, 1)
    end
    display.image { image = backgroundPath, color = bgColor, pos = vec2(0,0), size = vec2(1024,1024), uvStart = vec2(0,297/1024), uvEnd = vec2(1024/1024, 1175/2048) }
end

function displayBigSpeedText()
    speedInt, speedFloat = math.modf(car.speedKmh)
    display.text({text = string.format("%03d", math.floor(speedInt)), pos = vec2(75,8), letter = vec2(380,535), font = 'magicapixel', color = rgbm.colors.black, alignment = 1, width = 200, spacing = -200})
    display.text({text = math.floor(speedFloat*10), pos = vec2(700,180), letter = vec2(200,325), font = 'magicapixel', color = rgbm.colors.black, alignment = 1, width = 200, spacing = -125})
end

function parseString(str)
    if str == '' and string.len(str) then
        return "0"
    else
        return str
    end
end

function displayBigBoostText()
    local float_str = math.floor(car.turboBoost*100)
    display.text({text = math.floor(car.turboBoost), pos = vec2(200,8), letter = vec2(380,535), font = 'magicapixel', color = rgbm.colors.black, alignment = 1, width = 200, spacing = -150})
    display.text({text = parseString(string.sub(float_str, 1, 1)), pos = vec2(425,8), letter = vec2(380,535), font = 'magicapixel', color = rgbm.colors.black, alignment = 1, width = 200, spacing = -150})
    display.text({text = parseString(string.sub(float_str, 2, 2)), pos = vec2(670,180), letter = vec2(200,325), font = 'magicapixel', color = rgbm.colors.black, alignment = 1, width = 200, spacing = -150})
end

function handleBigScreenDisplay()
    if currentBigScreen == 1 then
        displayBigSpeedText()
    elseif currentBigScreen == 2 then
        displayBigBoostText()
    end
end

function displayBigScreen(pos, screenFlash)
    if screenFlash then
        setInterval(function ()
            flash = not flash
        end, flashScreenTimeSeconds, "key")

        if not flash then
            display.image { image = bigScreensPath, pos = vec2(4,8), size = vec2(1024,441), uvStart = pos["Start"], uvEnd = pos["End"] }
            handleBigScreenDisplay()
        end
    else
        display.image { image = bigScreensPath, pos = vec2(4,8), size = vec2(1024,441), uvStart = pos["Start"], uvEnd = pos["End"] }
        handleBigScreenDisplay()
    end
end

function displaySmallBoostText()
    local float_str = tostring(car.turboBoost)
    display.text({text = math.floor(car.turboBoost), pos = vec2(20,800), letter = vec2(225,260), font = 'magicapixel3', color = rgbm.colors.black, alignment = 1, width = 200, spacing = -160})
    display.text({text = parseString(string.sub(float_str, 3, 3)), pos = vec2(140,800), letter = vec2(225,260), font = 'magicapixel3', color = rgbm.colors.black, alignment = 1, width = 200, spacing = -160})
    display.text({text = parseString(string.sub(float_str, 4, 4)), pos = vec2(210,800), letter = vec2(225,260), font = 'magicapixel3', color = rgbm.colors.black, alignment = 1, width = 200, spacing = -160})
end

function displaySmallOilPressureText()
    oilPInt, oilPFloat = math.modf(car.oilPressure)
    display.text({text = oilPInt, pos = vec2(20,800), letter = vec2(225,260), font = 'magicapixel3', color = rgbm.colors.black, alignment = 1, width = 200, spacing = -160})
    display.text({text = string.format("%02d", math.floor(oilPFloat*100)), pos = vec2(140,800), letter = vec2(225,260), font = 'magicapixel3', color = rgbm.colors.black, alignment = 1, width = 200, spacing = -160})
end

function displaySmallFuelText()
    display.text({text = math.floor(car.fuel), pos = vec2(30,800), letter = vec2(225,260), font = 'magicapixel3', color = rgbm.colors.black, alignment = 1, width = 400, spacing = -160})
end

function handleSmallLeftScreenDisplay()
    if currentSmallLeftScreen == 1 then
        displaySmallBoostText()
    elseif currentSmallLeftScreen == 2 then
        displaySmallOilPressureText()
    elseif currentSmallLeftScreen == 3 then
        displaySmallFuelText()
    end
end

function displayLeftSmallScreen(pos, screenFlash)
    if screenFlash then
        setInterval(function ()
            flash = not flash
        end, flashScreenTimeSeconds, "key")

        if not flash then
            display.image { image = smallScreensPath, pos = vec2(5,527), size = vec2(515,488), uvStart = pos["Start"], uvEnd = pos["End"] }
            handleSmallLeftScreenDisplay()
        end
    else
        display.image { image = smallScreensPath, pos = vec2(5,527), size = vec2(515,488), uvStart = pos["Start"], uvEnd = pos["End"] }
        handleSmallLeftScreenDisplay()
    end
end

function displaySmallWaterTempText()
    waterInt, waterFloat = math.modf(car.waterTemperature)
    display.text({text = waterInt, pos = vec2(500,800), letter = vec2(225,260), font = 'magicapixel3', color = rgbm.colors.black, alignment = 1, width = 400, spacing = -160})
    display.text({text = math.floor(waterFloat*10), pos = vec2(800,800), letter = vec2(225,260), font = 'magicapixel3', color = rgbm.colors.black, alignment = 1, width = 200, spacing = -160})
end

function displaySmallOilTempText()
    oilTInt, oilTFloat = math.modf(car.oilTemperature)
    display.text({text = oilTInt, pos = vec2(500,800), letter = vec2(225,260), font = 'magicapixel3', color = rgbm.colors.black, alignment = 1, width = 400, spacing = -160})
    display.text({text = math.floor(oilTFloat*10), pos = vec2(800,800), letter = vec2(225,260), font = 'magicapixel3', color = rgbm.colors.black, alignment = 1, width = 200, spacing = -160})
end

function displaySmallOdometerText()
    display.text({text = math.floor(car.distanceDrivenTotalKm), pos = vec2(260,800), letter = vec2(225,260), font = 'magicapixel3', color = rgbm.colors.black, alignment = 1, width = 900, spacing = -160})
end

function handleSmallRightScreenDisplay()
    if currentSmallRightScreen == 1 then
        displaySmallWaterTempText()
    elseif currentSmallRightScreen == 2 then
        displaySmallOilTempText()
    elseif currentSmallRightScreen == 3 then
        displaySmallOdometerText()
    end
end

function displayRightSmallScreen(pos, screenFlash)
    if screenFlash then
        setInterval(function ()
            flash = not flash
        end, flashScreenTimeSeconds, "key")

        if not flash then
            display.image { image = smallScreensPath, pos = vec2(512,527), size = vec2(507,488), uvStart = pos["Start"], uvEnd = pos["End"] }
            handleSmallRightScreenDisplay()
        end
    else
        display.image { image = smallScreensPath, pos = vec2(512,527), size = vec2(507,488), uvStart = pos["Start"], uvEnd = pos["End"] }
        handleSmallRightScreenDisplay()
    end
end

function script.update(dt)
    if car.rpm < 50 then
        display.rect { pos = vec2(0,0), color = rgbm.colors.black, size = vec2(1024,1024) }
        boot = true
    elseif not boot then
        displayBackground()
        handleSelectScreenMode()
        displayBigScreen(allScreens[1][currentBigScreen], allScreens[1]["Flash"])
        displayLeftSmallScreen(allScreens[2][currentSmallLeftScreen], allScreens[2]["Flash"])
        displayRightSmallScreen(allScreens[3][currentSmallRightScreen], allScreens[3]["Flash"])
    else
        displayBackground()
        displayBootScreen()
    end
end