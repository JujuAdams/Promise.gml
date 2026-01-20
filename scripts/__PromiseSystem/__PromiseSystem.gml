// Feather disable all

// Promise.gml
// an adaptation of https://github.com/taylorhakes/promise-polyfill/

#macro __PROMISE_STATE_PENDING      0
#macro __PROMISE_STATE_FULFILLED    1
#macro __PROMISE_STATE_REJECTED     2
#macro __PROMISE_STATE_PASSTHROUGH  3

__PromiseSystem();

function __PromiseSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    with(_system)
    {
        show_debug_message("Welcome to Promise.gml by YellowAfterlife with edits by Juju Adams! Promise.gml is built on top of work by Taylor Hakes");
        
        __soonArray = [];
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            static _workArray = [];
            array_resize(_workArray, 0);
            
            var _soonCount = array_length(__soonArray);
            if (_soonCount <= 0)
            {
                return;
            }
            
            array_copy(_workArray, 0, __soonArray, 0, _soonCount);
            array_resize(__soonArray, 0);
            
            var _i = 0;
            repeat(_soonCount)
            {
                _workArray[_i]();
                ++_i;
            }
        },
        [], -1));
    }
    
    return _system;
}