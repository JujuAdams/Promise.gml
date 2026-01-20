// Feather disable all

function Promise(_handler)
{
    return new __PromiseConstructor(_handler);
}

function __PromiseConstructor(_handler) constructor
{
    if (not is_method(_handler)) show_error("Not a function", true);
    
    __handled = false;
    __state = 0;
    __value = undefined;
    __deferreds = [];
    
    static Then = function(_onFulfilled, _onRejected)
    {
        var _prom = new __PromiseConstructor(function(_resolve, _reject){});
        __Handle({
            __onFulfilled: _onFulfilled,
            __onRejected: _onRejected,
            __promise: _prom,
        });
        return _prom;
    }
    
    static Catch = function(_onRejected)
    {
        return Then(undefined, _onRejected);
    }
    
    static Finally = function(_callback)
    {
        with({
            __callback: _callback,
            __value: undefined,
        })
        {
            return other.Then(function(_value)
            {
                __value = _value;
                
                return PromiseResolve(__callback()).Then(function()
                {
                    return __value;
                })
            },
            function(_reason)
            {
                __value = _reason;
                
                return PromiseResolve(__callback()).Then(function()
                {
                    return PromiseReject(__value);
                })
            })
        }
    };
    
    static toString = function()
    {
        return $"Promise(state={__state}, value={__value}, deferreds={array_length(__deferreds)})";
    }
    
    static __DoResolve = function(_func)
    {
        var _self = self;
        with({
            __done: false,
            __self: _self,
        })
        {
            try
            {
                _func(function(_value)
                {
                    if (__done) return;
                    
                    __done = true;
                    __self.__Resolve(_value);
                },
                function(_reason)
                {
                    if (__done) return;
                    
                    __done = true;
                    __self.__Reject(_reason);
                });
            }
            catch(_err)
            {
                if (__done) return;
                
                __done = true;
                _self.__Reject(_err);
            }
        }
    }
    
    static __Handle = function(_deferred)
    {
        static _staticSoonArray = __PromiseSystem().__soonArray;
        var _soonArray = _staticSoonArray;
        
        var _self = self;
        while (_self.__state == 3) _self = _self.__value;
        with(_self)
        {
            if (__state == 0)
            {
                array_push(__deferreds, _deferred);
                return;
            }
            
            __handled = true;
            
            with({
                __self: _self,
                __deff: _deferred,
            })
            {
                array_push(_soonArray, function()
                {
                    var _deff = __deff;
                    with(__self) {
                        var _cb = __state == 1 ? _deff.__onFulfilled : _deff.__onRejected;
                        if (_cb == undefined)
                        {
                            if (__state == 1)
                            {
                                _deff.__promise.__Resolve(__value);
                            }
                            else
                            {
                                _deff.__promise.__Reject(__value);
                            }
                            
                            return;
                        }
                        
                        var _ret;
                        try
                        {
                            _ret = _cb(__value);
                        }
                        catch(_err)
                        {
                            _deff.__promise.__Reject(_err);
                            return;
                        }
                        _deff.__promise.__Resolve(_ret);
                    }
                });
            }
        }
    }
    
    static __Resolve = function(_newValue)
    {
        try
        {
            // Promise Resolution Procedure:
            // https://github.com/promises-aplus/promises-spec#the-promise-resolution-procedure
            if (_newValue == self) show_error("A promise cannot be resolved with itself.", true);
            
            if (is_struct(_newValue) || is_method(_newValue))
            {
                if (is_instanceof(_newValue, __PromiseConstructor))
                {
                    __state = 3;
                    __value = _newValue;
                    __Finale();
                    return;
                }
                
                var _then = _newValue[$ "Then"];
                if (is_method(_then))
                {
                    __DoResolve(method(_newValue, _then));
                    return;
                }
            }
            __state = 1;
            __value = _newValue;
            __Finale();
        }
        catch(_e)
        {
            __Reject(_newValue);
        }
    }
    
    static __Reject = function(_newValue)
    {
        __state = 2;
        __value = _newValue;
        __Finale();
    }
    
    static __Finale = function()
    {
        static _soonArray = __PromiseSystem().__soonArray;
        
        var _length = array_length(__deferreds);
        if ((__state == 2) && (_length == 0))
        {
            array_push(_soonArray, function()
            {
                if (not __handled)
                {
                    show_debug_message($"Unhandled promise rejection: {__value}");
                }
            });
        }
        
        var _i = 0;
        repeat(_length)
        {
            __Handle(__deferreds[_i]);
            ++_i;
        }
        
        __deferreds = undefined;
    }
    
    __DoResolve(_handler);
}