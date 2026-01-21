// Feather disable all

function Promise_buffer_async_group_end()
{
    static _callbackDict = __PromiseSystem().__callbackDict;
    __PromiseEnsureInstance();
    
    var _promise = PromiseCustom();
    
    try
    {
        var _index = buffer_async_group_end();
    }
    catch(_error)
    {
        show_debug_message(json_stringify(_error, true));
        var _index = -1;
    }
    
    if (_index >= 0)
    {
        _callbackDict[$ $"Save/Load {_index}"] = _promise;
    }
    else
    {
        _promise.Reject({ id: -1, status: false });
    }
    
    return _promise;
}