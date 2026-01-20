// Feather disable all

function PromiseResolve(_value)
{
    if (is_instanceof(_value, __PromiseConstructor))
    {
        return _value;
    }
    
    with({ __value: _value })
    {
        return new __PromiseConstructor(function(_resolve, _reject)
        {
            _resolve(__value);
        });
    }
}