// Feather disable all

/// @param url

function Promise_http_get(_url)
{
    static _callbackDict = __PromiseSystem().__callbackDict;
    
    __PromiseEnsureInstance();
    
    var _promise = PromiseCustom();
    
    var _index = http_get(_url);
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