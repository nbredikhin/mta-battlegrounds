Languages = {}

function getLanguageString(language, name)
    if not Languages[language] or not Languages[language][name] then
        return name
    end
    return Languages[language][name]
end
