// Feather disable all

/// @param fulfill
/// @param reject

function __PromiseClassDeferred(_onFulfilled, _onRejected) constructor
{
    __onFulfilled = _onFulfilled;
    __onRejected  = _onRejected;
    
    __promise = new __PromiseClass();
}