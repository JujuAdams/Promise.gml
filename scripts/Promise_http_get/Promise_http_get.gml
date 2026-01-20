// Feather disable all

/// @param url

function Promise_http_get(_url)
{
    __PromiseEnsureInstance();
    
    return new __PromiseConstructor(
        method({
            __url:     _url,
            __Resolve: undefined,
            __Reject:  undefined,
        },
        function(_resolve, _reject)
        {
            static _callbackDict = __PromiseSystem().__callbackDict;
            
            __Resolve = _resolve;
            __Reject  = _reject;
            
            var _index = http_get(__url);
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