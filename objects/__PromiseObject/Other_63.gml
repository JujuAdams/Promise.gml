// Feather disable all

with(__PromiseSystem())
{
    var _key = $"Dialog {async_load[? "id"]}";
    with(__callbackDict[$ _key])
    {
        struct_remove(other.__callbackDict, _key);
        
        var _asyncStruct = json_parse(json_encode(async_load));
        if (_asyncStruct[$ "status"])
        {
            Resolve(_asyncStruct);
        }
        else
        {
            Reject(_asyncStruct);
        }
    }
}