// Feather disable all

function PromiseReject(_value)
{
    with({ __value: _value })
    {
        return new __PromiseConstructor(function(_resolve, _reject)
        {
            _reject(__value);
        });
    }
}