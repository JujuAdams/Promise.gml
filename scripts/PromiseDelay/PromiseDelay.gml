// Feather disable all

/// Creates and returns a promise that is automatically resolved after a certain amount of real
/// time has passed. You may optionally provide a value to pass to the resolution using the `value`
/// parameter.
/// 
/// @param milliseconds
/// @param [value]

function PromiseDelay(_milliseconds, _value = undefined)
{
    static _timeoutPQ = __PromiseSystem().__timeoutPQ;
    
    var _promise = new __PromiseClass();
    ds_priority_add(_timeoutPQ,
                        method({
                            __function: method(_promise, _promise.__Resolve),
                            __value: _value,
                        },
                        function()
                        {
                            return __function(__value);
                        }),
                    current_time + _milliseconds);
    return _promise;
}