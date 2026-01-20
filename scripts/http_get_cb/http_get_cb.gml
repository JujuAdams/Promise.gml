globalvar __http_get_cb_map; __http_get_cb_map = ds_map_create();
function __http_get_cb_async() {
    var _status = async_load[?"status"];
    if (_status > 0) exit;
    var _id = async_load[?"id"];
    var _func = __http_get_cb_map[?_id];
    if (_func == undefined) exit;
    ds_map_delete(__http_get_cb_map, _id);
    _func(json_parse(json_encode(async_load)));
}
function http_get_cb(_url, _func) {
    var _index = http_get(_url);
    if (_index >= 0) __http_get_cb_map[?_index] = _func;
}

function http_get_promise(_url) {
    with({
        __url: _url,
        __Resolve: undefined,
        __Reject: undefined,
    }) return Promise(function(_resolve, _reject) {
        __Resolve = _resolve;
        __Reject = _reject;
        http_get_cb(__url, function(_obj) {
            if (_obj.status == 0) {
                __Resolve(_obj.result);
            } else {
                __Reject("HTTP " + string(_obj.http_status));
            }
        })
    });
}