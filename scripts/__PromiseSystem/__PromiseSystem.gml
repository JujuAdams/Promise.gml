// Feather disable all

// Promise.gml
// an adaptation of https://github.com/taylorhakes/promise-polyfill/

__PromiseSystem();

function __PromiseSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    with(_system)
    {
        show_debug_message("Welcome to Promise.gml by Juju Adams! Promise.gml is built on top of work by YellowAfterlife and Taylor Hakes");
        
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