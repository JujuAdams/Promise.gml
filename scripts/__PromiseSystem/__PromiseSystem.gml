// Feather disable all

globalvar Promise; Promise = __PromiseSystem().__function;
Promise.update = __Promise_update;
Promise.resolve = Promise_resolve;
Promise.reject = Promise_reject;
Promise.afterAll = Promise_all;
Promise.allSettled = Promise_allSettled;
Promise.race = Promise_race;

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