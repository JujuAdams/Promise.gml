// Feather disable all

/// @param string
/// @param default

function Promise_get_string_async(_string, _default)
{
    static _callbackDict = __PromiseSystem().__callbackDict;
    __PromiseEnsureInstance();
    
    var _promise = PromiseCustom();
    
    try
    {
        var _index = get_string_async(_string, _default);
    }
    catch(_error)
    {
        show_debug_message(json_stringify(_error, true));
        var _index = -1;
    }
    
    if (_index >= 0)
    {
        _callbackDict[$ $"Dialog {_index}"] = _promise;
    }
    else
    {
        _promise.Reject({ id: -1, status: false, result: "" });
    }
    
    return _promise;
}