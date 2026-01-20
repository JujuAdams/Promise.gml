// Feather disable all

function PromiseReject(_value)
{
    with({
        __value: _value
    })
    {
        return new __PromiseClass(function(_resolve, _reject)
        {
            _reject(__value);
        });
    }
}