// Feather disable all

/// @param url
/// @param method
/// @param headerMap
/// @param body

function Promise_http_request(_url, _method, _headerMap, _body)
{
    __PromiseEnsureInstance();
    
    if (_headerMap == undefined)
    {
        var _headerStruct = undefined;
    }
    else if (is_struct(_headerMap))
    {
        var _headerStruct = _headerMap;
    }
    else
    {
        var _headerStruct = json_parse(json_encode(_headerMap));
    }
    
    return new __PromiseConstructor(
        method({
            __url:          _url,
            __method:       _method,
            __headerStruct: _headerStruct,
            __body:         _body,
            __Resolve:      undefined,
            __Reject:       undefined,
        },
        function(_resolve, _reject)
        {
            static _callbackDict = __PromiseSystem().__callbackDict;
            
            __Resolve = _resolve;
            __Reject  = _reject;
            
            var _headerMap = (__headerStruct == undefined)? ds_map_create() : json_encode(json_stringify(__headerStruct));
            var _index = http_request(__url, __method, _headerMap, __body);
            ds_map_destroy(_headerMap);
            
            if (_index >= 0)
            {
                _callbackDict[$ $"HTTP {_index}"] = self;
            }
            else
            {
                __Reject({ id: -1, status: -1, http_status: 404, result: "", url: __url, response_headers: {} });
            }
        })
    );
}