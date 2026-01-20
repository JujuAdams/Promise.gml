// Feather disable all

function PromiseAllSettled(_arr)
{
    with({__arr: _arr})
    {
        return new __PromiseConstructor(function(_resolve, _reject)
        {
            if (not is_array(__arr))
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
            
            var _len = array_length(__arr);
            var _args = array_create(_len);
            if (_len == 0) return _resolve(_args);
            array_copy(_args, 0, __arr, 0, _len);
            
            var _remaining = [_len];
            for (var _ind = 0; _ind < _len; _ind++)
            {
                __PromiseAllSettledResult(_args, _ind, _args[_ind], _resolve, _reject, _remaining);
            }
        });
    }
}

function __PromiseAllSettledResult(_args, _ind, _val, _resolve, _reject, _remaining)
{
    try
    {
        if (is_struct(_val) && is_method(_val[$ "Then"]))
        {
            with({
                __ind: _ind,
                __args: _args,
                __Resolve: _resolve,
                __Reject: _reject,
                __remaining: _remaining,
            })
            {
                _val.Then(
                    function(_val)
                    {
                        __PromiseAllSettledResult(__args, __ind, _val, __Resolve, __Reject, __remaining);
                    },
                    function(_err)
                    {
                        __args[@ __ind] = {
                            success: false,
                            reason: _err,
                        };
                        
                        if ((--__remaining[@ 0]) == 0)
                        {
                            __Resolve(__args);
                        }
                    }
                );
            }
            
            return;
        }
        
        _args[@ _ind] = {
            success: true,
            value: _val,
        };
        
        if ((--_remaining[@ 0]) == 0)
        {
            _resolve(_args);
        }
    }
    catch(_e)
    {
        _reject(_e);
    }
}