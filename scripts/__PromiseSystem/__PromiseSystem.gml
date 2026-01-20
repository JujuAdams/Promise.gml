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
        
        __function = method({}, __PromiseConstructor);
        __soon = ds_list_create();
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
        	if (ds_list_empty(__soon)) return;
            
        	static _copy = ds_list_create();
        	ds_list_clear(_copy);
        	
            ds_list_copy(_copy, __soon);
        	ds_list_clear(__soon);
            
        	var _len = ds_list_size(_copy);
        	for (var _ind = 0; _ind < _len; _ind++)
            {
        		_copy[| _ind]();
        	}
        	
            ds_list_clear(_copy);
        },
        [], -1));
    }
    
    return _system;
}