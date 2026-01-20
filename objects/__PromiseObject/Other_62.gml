// Feather disable all

with(__PromiseSystem())
{
    var _status = async_load[?"status"];
    if (_status > 0) return;
    
    var _key = $"HTTP {async_load[? "id"]}";
    with(__callbackDict[$ _key])
    {
        struct_remove(other.__callbackDict, _key);
        
        var _asyncStruct = json_parse(json_encode(async_load));
        _asyncStruct.response_headers = json_parse(json_encode(async_load[? "response_headers"]));
        
        if (_asyncStruct[$ "status"] == 0)
        {
            __Resolve(_asyncStruct);
        }
        else
        {
            __Reject(_asyncStruct);
        }
    }
}