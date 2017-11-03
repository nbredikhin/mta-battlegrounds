ItemClasses = {}

function getItemClass(item)
    if isItem(item) then
        return ItemClasses[item.name]
    end
end
