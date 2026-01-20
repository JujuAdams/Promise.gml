// Feather disable all

/// @param url
/// @param dest

function Promise_http_get_file(_url, _filename)
{
    __PromiseEnsureInstance();
    
    return new __PromiseConstructor(
        method({
            __url:      _url,
            __filename: _filename,
            __Resolve:  undefined,
            __Reject:   undefined,
        },
        function(_resolve, _reject)
        {
            static _callbackDict = __PromiseSystem().__callbackDict;
            
            __Resolve = _resolve;
            __Reject  = _reject;
            
            var _index = http_get_file(__url, __filename);
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