// Feather disable all

function PromiseRace(_arr)
{
    with({
        __arr: _arr
    })
    {
        return new __PromiseConstructor(function(_resolve, _reject)
        {
            if (not is_array(__arr))
            {
                try
                {
                    show_error("Race() accepts an array", 0);
                }
                catch(_e)
                {
                    return _reject(_e);
                }
            }
            
            var _i = 0;
            repeat(array_length(__arr))
            {
                PromiseResolve(__arr[_i]).Then(_resolve, _reject);
                ++_i;
            }
        });
    }
}