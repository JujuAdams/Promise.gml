// Feather disable all

/// Creates a promise with exposed resolve and reject functions. This sort of promise can be used
/// more easily with other GameMaker features, especially native Asunc Events. When you'd like to
/// pass a value back into a promise, call either of the following two functions:
/// 
/// .Resolve(value)
///     Passes the value back into the promise as a successful operation.
/// 
/// .Reject(value)
///     Passes the value back into the promise as a failed operation.
/// 
/// N.B. You will only be able to call either of these functions once and the functions are
///      mutually exclusive.
/// 
/// Promises created with this function are not guaranteed to complete because the promise will
/// wait until `.Resolve()` or `.Reject()` are called. If you forget to call these functions then
/// then promise will never proceed which can cause bugs. One solution is to set up a timeout
/// behaviour e.g. using `PromiseTimeout()`. However, a timeout is not always suitable.
/// 
/// If it is essential for a promise to complete then you may optionally specify a scope (a struct
/// or an object instance) for the promise to track. Once that scope has been garbage collected
/// (for structs) or destroyed (for instances) then the promise will be rejected using the provided
/// out-of-scope value.
/// 
/// N.B. Rejecting a promise due to it falling out of scope is not instant. Promise scope will be
///      checked with a fixed period as defined by `PROMISE_SCOPE_TEST_PERIOD`.
/// 
/// @param [scope]
/// @param [outOfScopeValue]

function PromiseCustom(_scope = undefined, _outOfScopeValue = undefined)
{
    var _promise = new __PromiseClassCustom();
    
    if (is_struct(_scope))
    {
        new __PromiseClassScopeStruct(_promise, _scope, _outOfScopeValue);
    }
    else if (instance_exists(_scope))
    {
        new __PromiseClassScopeInstance(_promise, _scope, _outOfScopeValue);
    }
    else if (_scope != undefined)
    {
        if (PROMISE_RUNNING_FROM_IDE)
        {
            __PromiseError($"Scope must be a struct or an instance (type=\"{typeof(_scope)}\"");
        }
        else
        {
            __PromiseTrace($"Warning! Scope must be a struct or an instance (type=\"{typeof(_scope)}\"");
        }
    }
    
    return _promise;
}