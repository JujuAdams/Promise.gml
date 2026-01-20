// Feather disable all

function __PromiseSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    with(_system)
    {
        __function = method({}, __Promise);
        __soon = ds_list_create();
    }
    
    return _system;
}