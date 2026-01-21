// Feather disable all

// Promise.gml
// https://github.com/YAL-GameMaker/Promise.gml
// 
// Made by YellowAfterlif
// An adaptation of https://github.com/taylorhakes/promise-polyfill/
// Editted by Juju Adams

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
        show_debug_message("Welcome to Promise.gml by YellowAfterlife with edits by Juju Adams! Promise.gml is built on top of work by Taylor Hakes. This is version 1.1.0, 2026-01-20");
        
        __soonArray = [];
        __timeoutPQ = ds_priority_create();
        
        __callbackDict = {};
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            //Handle delayed promises made by `PromiseDelay()` or `PromiseTimeout()`
            var _pq = __timeoutPQ;
            while (not ds_priority_empty(_pq))
            {
                var _function = ds_priority_find_min(_pq);
                if (ds_priority_find_priority(_pq, _function) > current_time)
                {
                    break;
                }
                
                ds_priority_delete_min(_pq);
                _function();
            }
            
            //Handle globally deferred promise resolution
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