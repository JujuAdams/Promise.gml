// Feather disable all

function PromiseAllSettled(_array)
{
    with({
        __array: _array
    })
    {
        return new __PromiseConstructor(function(_resolve, _reject)
        {
            if (not is_array(__array))
            {
                try
                {
                    show_error("AllSettled() accepts an array", 0);
                }
                catch(_e)
                {
                    return _reject(_e);
                }
            }
            
            var _length = array_length(__array);
            var _arguments = array_create(_length);
            if (_length == 0) return _resolve(_arguments);
            
            array_copy(_arguments, 0, __array, 0, _length);
            var _remaining = [_length];
            
            var _i = 0;
            repeat(_length)
            {
                __PromiseAllSettledResult(_arguments, _i, _arguments[_i], _resolve, _reject, _remaining);
                ++_i;
            }
        });
    }
}

function __PromiseAllSettledResult(_arguments, _index, _value, _resolve, _reject, _remaining)
{
    try
    {
        if (is_struct(_value) && is_method(_value[$ "Then"]))
        {
            with({
                __index:     _index,
                __arguments: _arguments,
                __Resolve:   _resolve,
                __Reject:    _reject,
                __remaining: _remaining,
            })
            {
                _value.Then(
                    function(_value)
                    {
                        __PromiseAllSettledResult(__arguments, __index, _value, __Resolve, __Reject, __remaining);
                    },
                    function(_err)
                    {
                        __arguments[@ __index] = {
                            success: false,
                            value:   undefined,
                            reason: _err,
                        };
                        
                        if ((--__remaining[@ 0]) == 0)
                        {
                            __Resolve(__arguments);
                        }
                    }
                );
            }
            
            return;
        }
        
        _arguments[@ _index] = {
            success: true,
            value:   _value,
            reason:  undefined,
        };
        
        if ((--_remaining[@ 0]) == 0)
        {
            _resolve(_arguments);
        }
    }
    catch(_e)
    {
        _reject(_e);
    }
}