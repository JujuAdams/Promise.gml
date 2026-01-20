// Feather disable all

function PromiseRace(_arr)
{
    with({__arr: _arr})
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
            
            var _len = array_length(__arr);
            for (var _ind = 0; _ind < _len; _ind++)
            {
                PromiseResolve(__arr[_ind]).Then(_resolve, _reject);
            }
        });
    }
}