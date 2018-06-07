local currentLanguage = "english"

local languagesTable = {
    english = true,
    russian = true
}

function setLanguage(language)
    if not language or not Languages[language] then
        return
    end
    currentLanguage = language
    saveFile("language", language)

    triggerEvent("onLanguageChanged", resourceRoot, language)
end

function getLanguage()
    return currentLanguage
end

function localize(name)
    return getLanguageString(currentLanguage, name)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local defaultLanguage = "english"
    if string.find(string.lower(getLocalization().code), "ru") then
        defaultLanguage = "russian"
    end
    setLanguage(loadFile("language") or defaultLanguage)
end)

addCommandHandler("language", function (cmd, language)
    if not language or not languagesTable[language] then
        local lang = next(languagesTable, currentLanguage)
        if not lang then
            lang = next(languagesTable)
        end
        language = lang
    end

    setLanguage(language)
    outputConsole("Language changed to " .. tostring(language))
end)
