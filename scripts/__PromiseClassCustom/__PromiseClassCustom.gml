// Feather disable all

/// Copy of the base promise class but with exposed resolve/reject methods. This makes it easier
/// to integrate promises with other parts of GameMaker.

function __PromiseClassCustom() : __PromiseClass() constructor
{
    __ExecuteHandler(function(_resolve, _reject)
    {
        Resolve = _resolve;
        Reject  = _reject;
    });
}