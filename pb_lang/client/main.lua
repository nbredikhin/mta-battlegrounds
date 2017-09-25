local currentLanguage = "english"

function setLanguage(language)
    if not language or not Languages[language] then
        return
    end
    iprint("UI language changed to " .. tostring(language))
    currentLanguage = language
    saveFile("language", language)
end

function localize(name)
    return getLanguageString(currentLanguage, name)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    setLanguage(loadFile("language") or "english")
    currentLanguage = "russian"
end)
