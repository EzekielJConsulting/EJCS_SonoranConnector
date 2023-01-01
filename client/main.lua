function apiCall(callCat, callType, data)
    -- Body payload object
    local payload = {}

    -- Specify our community ID, API key, and API method type (Panic)
    payload["id"] = config.communityID
    payload["key"] = config.apiKey
    payload["type"] = callType

    -- Add this data to our payload
    payload["data"] = data

    -- Send POST request with JSON encoded body (payload)
    PerformHttpRequest(config.apiBase..string.lower(callCat).."/"..string.lower(callType), 
        function(statusCode, res, headers)
            if statusCode == 200 and res ~= nil then
                -- Status code 200 (Success)
                return tostring(res)
                print("result: "..tostring(res))
            else
                return false
                -- Error code
                print(("CAD API ERROR: %s %s"):format(statusCode, res))
            end
        end, 
        "POST", 
        json.encode(payload), 
        {["Content-Type"]="application/json"}
    )
end

RegisterNetEvent('EJDS_SonoranConnector:add911')
AddEventHandler('EJDS_SonoranConnector:add911', function (callerName, location, callDesc, xCoordinate, yCoordinate)
    local metaData = nil
    if xCoordinate and yCoordinate then
        metaData = {
            "x":xCoordinate,
            "y":yCoordinate
        }
    else
        metaData = nil
    end
    
    local callData = {
        "serverId": 1, --Server ID Integer
        "isEmergency": true, --Displays EMERGENCY or CIVIL type in the CAD
        "caller": callerName, --PlayerName
        "location": location, --Location of Call
        "description": callDesc, --Call Details
        "metaData": metaData -- OPTIONAL: X & Y Corrdinates for livemap
    }
    apiCall("emergency", "CALL_911", callData)
end)
  