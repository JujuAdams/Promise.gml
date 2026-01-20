// Feather disable all

function PromiseRace(_array)
{
    with({
        __array: _array
    })
    {
        return new __PromiseClass(function(_resolve, _reject)
        {
            if (not is_array(__array))
            {
                try
                {
                    show_error("Race() accepts an array", 0);
                }
                catch(_error)
                {
                    return _reject(_error);
                }
            }
            
            var _i = 0;
            repeat(array_length(__array))
            {
                PromiseResolve(__array[_i]).Then(_resolve, _reject);
                ++_i;
            }
        });
    }
}