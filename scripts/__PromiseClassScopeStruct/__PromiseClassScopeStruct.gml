// Feather disable all

/// @param promise
/// @param struct
/// @param outOfScopeValue

function __PromiseClassScopeStruct(_promise, _struct, _outOfScopeValue) constructor
{
    __promise         = _promise;
    __weakRef         = weak_ref_create(_struct);
    __outOfScopeValue = _outOfScopeValue;
    
    __timeSource = time_source_create(time_source_global, PROMISE_SCOPE_TEST_PERIOD, time_source_units_seconds, function()
    {
        if (not weak_ref_alive(__weakRef))
        {
            time_source_stop(__timeSource);
            time_source_destroy(__timeSource);
            
            __promise.Reject(__outOfScopeValue);
        }
        else if (__promise.__state != __PROMISE_STATE_PENDING)
        {
            time_source_stop(__timeSource);
            time_source_destroy(__timeSource);
        }
    },
    [], -1);
    
    time_source_start(__timeSource);
}