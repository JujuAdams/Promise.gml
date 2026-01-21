// Feather disable all

/// @param url
/// @param dest

function Promise_http_get_file(_url, _filename)
{
    static _callbackDict = __PromiseSystem().__callbackDict;
    __PromiseEnsureInstance();
    
    var _promise = PromiseCustom();
    
    try
    {
        var _index = http_get_file(_url, _filename);
    }
    catch(_error)
    {
        show_debug_message(json_stringify(_error, true));
        var _index = -1;
    }
    
    if (_index >= 0)
    {
        _callbackDict[$ $"HTTP {_index}"] = _promise;
    }
    else
    {
        _promise.Reject({ id: -1, status: -1, http_status: 404, result: "", url: _url, response_headers: {} });
    }
    
    return _promise;
}