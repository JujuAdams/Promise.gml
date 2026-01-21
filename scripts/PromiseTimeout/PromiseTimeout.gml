// Feather disable all

/// Creates and returns a promise that is automatically rejected after a certain amount of real
/// time has passed. You may optionally provide a value to pass to the rejection using the
/// `rejectValue` parameter.
/// 
/// @param milliseconds
/// @param [rejectValue]
/// @param handlerOrPromise

function PromiseTimeout(_milliseconds, _rejectValue = undefined, _handlerOrPromise)
{
    static _timeoutPQ = __PromiseSystem().__timeoutPQ;
    
    if (is_instanceof(_handlerOrPromise, __PromiseClass))
    {
        var _promise = _handlerOrPromise;
    }
    else
    {
        var _promise = Promise(_handlerOrPromise);
    }
    
    var _promise = new __PromiseClass();
    ds_priority_add(_timeoutPQ,
                        method({
                            __function: method(_promise, _promise.__Reject),
                            __rejectValue: _rejectValue,
                        },
                        function()
                        {
                            return __function(__rejectValue);
                        }),
                    current_time + _milliseconds);
    
    return _promise;
}