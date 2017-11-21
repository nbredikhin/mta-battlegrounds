
local unix_socket, host, port = unix_socket, host, port
local dbname, user, password = dbname, user, password
local mainDB

function connect()
	local startTick = getTickCount()
	mainDB = dbConnect("mysql", (unix_socket and "unix_socket="..unix_socket or "host="..host)..";dbname="..dbname .. (port and ";port="..port or ""), user, password)
	if (mainDB) then
		outputDebugString("[MYSQL] Connection: "..getTickCount()-startTick.." ms.")
	else
		outputDebugString("[MYSQL][ERROR] Connection failed!", 1)
		setTimer(connect, 5000, 1)
	end
end
connect()


_dbQuery = dbQuery
function dbQuery(timeout, tableName, query, ...)
	local result, errorCode, errorMessage = dbPoll(_dbQuery(mainDB, query, getResourceName(sourceResource).."_"..tableName, ...), timeout)
	if (not result) then
		outputDebugString (string.format("[MYSQL][ERROR] dbQuery error on %s (table `%s`)", query, tableName), 1)
	end
	return result, errorCode, errorMessage
end


function dbQueryAsync(callbackFunctionName, callbackArguments, tableName, query, ...)
	local extraData = {
		sourceResourceRoot,
		callbackFunctionName,
		callbackArguments,
	}
	return _dbQuery(dbCallback, extraData, mainDB, query, getResourceName(sourceResource).."_"..tableName, ...)
end
function dbCallback(queryHandle, srcResRoot, callbackFunctionName, callbackArguments)
	local result, errorCode, errorMessage = dbPoll(queryHandle, 0)
	if (not result) then
		outputDebugString (string.format("[MYSQL][ERROR] dbCallback error %i (%s)", errorCode, errorMessage), 1)
	end
	triggerEvent("dbCallback", srcResRoot, result, callbackFunctionName, callbackArguments)
end


_dbExec = dbExec
function dbExec(tableName, query, ...)
	-- Сюда тоже следует добавить проверку, не отвалилась ли у нас база, но увы...
	return _dbExec(mainDB, query, getResourceName(sourceResource).."_"..tableName, ...)
end


function getTableName(tableName)
	return getResourceName(sourceResource).."_"..tableName
end


_dbPrepareString = dbPrepareString
function dbPrepareString(tableName, query, ...)
	return _dbPrepareString(mainDB, query, getResourceName(sourceResource).."_"..tableName, ...)
end


local multipleQueryTable = {}
function dbQueryAsyncMultiple(callbackFunctionName, callbackArguments, ...)
	local queries = {...}
	local packID = generateID()
	while (multipleQueryTable[packID]) do
		packID = generateID()
	end

	multipleQueryTable[packID] = {
		sourceResourceRoot = sourceResourceRoot,
		callbackFunctionName = callbackFunctionName,
		callbackArguments = callbackArguments,
		numberOfQueries = #queries,
		replies = {},
	}

	for queryNumber, query in ipairs(queries) do
		local extraData = {
			packID,
			queryNumber,
		}
		_dbQuery(multipleQueryCallback, extraData, mainDB, query.query, getResourceName(sourceResource).."_"..query.tableName, unpack(query))
	end
end
function multipleQueryCallback(queryHandle, packID, queryNumber)
	local result, errorCode, errorMessage = dbPoll(queryHandle, 0)
	if (not result) then
		outputDebugString(string.format("[MYSQL][ERROR] multipleQueryCallback error %i (%s)", errorCode, errorMessage), 1)
	end

	local queryTable = multipleQueryTable[packID]
	queryTable.replies[queryNumber] = {
		result = result,
		errorCode = errorCode,
		errorMessage = errorMessage,
	}

	if (#queryTable.replies == queryTable.numberOfQueries) then
		triggerEvent("dbCallback", queryTable.sourceResourceRoot, queryTable.replies, queryTable.callbackFunctionName, queryTable.callbackArguments)
		multipleQueryTable[packID] = nil
	end
end

--[[
dbQueryAsyncMultiple(string callbackFunctionName, table callbackArguments, ...)
Там, где многоточие - по таблице такого вида на каждый запрос:
{
	string tableName,
	string query,
	аргументы через запятую
}

Результаты будут в таблице, с сохранением очередности выполненных запросов. Таблица вида:
{
	{
		table result,
		number errorCode,
		string errorMessage,
	},
}
]]

-- ==========     Генерация строки символов     ==========
local symbols = {}
for _, range in ipairs({{48, 57}, {65, 90}, {97, 122}}) do -- numbers/lowercase chars/uppercase chars
	for i = range[1], range[2] do
		table.insert(symbols, string.char(i))
	end
end
local symbolCount = #symbols
function generateID()
	local str = ""
	for i = 1, 8 do
		str = str..symbols[math.random(1, symbolCount)]
	end
	return str
end
