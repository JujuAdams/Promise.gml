// Feather disable all

/// @param url
/// @param method
/// @param headerMap
/// @param body

function Promise_http_request(_url, _method, _headerMap, _body)
{
    static _callbackDict = __PromiseSystem().__callbackDict;
    __PromiseEnsureInstance();
    
    var _promise = PromiseCustom();
    
    var _cleanUp = false;
    if (_headerMap == undefined)
    {
        _headerMap = ds_map_create();
        _cleanUp = true;
    }
    else if (is_struct(_headerMap))
    {
        _headerMap = json_encode(json_stringify(_headerMap));
        _cleanUp = true;
    }
    
    try
    {
        var _index = http_request(_url, _method, _headerMap, _body);
    }
    catch(_error)
    {
        show_debug_message(json_stringify(_error, true));
        var _index = -1;
    }
    
    if (_cleanUp)
    {
        ds_map_destroy(_headerMap);
    }
            
    if (_index >= 0)
    {
        _callbackDict[$ $"HTTP {_index}"] = self;
    }
    else
    {
        _promise.Reject({ id: -1, status: -1, http_status: 404, result: "", url: _url, response_headers: {} });
    }
    
    return _promise;
}