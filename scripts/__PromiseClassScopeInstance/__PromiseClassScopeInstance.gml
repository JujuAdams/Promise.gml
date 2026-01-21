// Feather disable all

/// @param promise
/// @param instance
/// @param outOfScopeValue

function __PromiseClassScopeInstance(_promise, _instance, _outOfScopeValue) constructor
{
    __promise         = _promise;
    __instance        = _instance;
    __outOfScopeValue = _outOfScopeValue;
    
    __timeSource = time_source_create(time_source_global, PROMISE_SCOPE_TEST_PERIOD, time_source_units_seconds, function()
    {
        if (not instance_exists(__instance))
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