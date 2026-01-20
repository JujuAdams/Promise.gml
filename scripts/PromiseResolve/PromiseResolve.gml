// Feather disable all

function PromiseResolve(_value)
{
    if (is_instanceof(_value, __PromiseClass))
    {
        return _value;
    }
    
    with({
        __value: _value
    })
    {
        return new __PromiseClass(function(_resolve, _reject)
        {
            _resolve(__value);
        });
    }
}