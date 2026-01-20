globalvar __get_string_cb_map; __get_string_cb_map = ds_map_create();
function __get_string_cb_async() {
    var _id = async_load[?"id"];
    var _func = __get_string_cb_map[?_id];
    if (_func == undefined) exit;
    ds_map_delete(__get_string_cb_map, _id);
    _func(json_parse(json_encode(async_load)));
}

function get_string_cb(_message, _default, _func) {
    var _ind = get_string_async(_message, _default);
    if (_ind >= 0) __get_string_cb_map[?_ind] = _func;
}

function get_string_promise(_message, _default) {
    with({
        __message: _message,
        __default: _default,
        __Resolve: undefined,
        __Reject: undefined,
    }) return new Promise(function(_resolve, _reject) {
        __Resolve = _resolve;
        __Reject = _reject;
        get_string_cb(__message, __default, function(_obj) {
            if (_obj.status) {
                __Resolve(_obj.result);
            } else {
                __Reject(undefined);
            }
        })
    });
}