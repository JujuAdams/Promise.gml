// Feather disable all

function __PromiseClassCustom() : __PromiseClass() constructor
{
    __ExecuteHandler(function(_resolve, _reject)
    {
        Resolve = _resolve;
        Reject  = _reject;
    });
}