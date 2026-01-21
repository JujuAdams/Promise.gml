// Feather disable all

/// @param url

function Promise_http_get(_url)
{
    static _callbackDict = __PromiseSystem().__callbackDict;
    __PromiseEnsureInstance();
    
    var _promise = PromiseCustom();
    
    try
    {
        var _index = http_get(_url);
    }
    catch(_error)
    {
        if (PROMISE_VERBOSE_HTTP_ERRORS)
        {
            show_debug_message(json_stringify(_error, true));
        }
        
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