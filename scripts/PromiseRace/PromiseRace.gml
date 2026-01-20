// Feather disable all

function PromiseRace(_array)
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
                    show_error("Race() accepts an array", 0);
                }
                catch(_e)
                {
                    return _reject(_e);
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