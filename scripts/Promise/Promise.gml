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
        self.__Handle({
            onFulfilled: _onFulfilled,
            onRejected: _onRejected,
            promise: _prom,
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
                        var _cb = __state == 1 ? _deff.onFulfilled : _deff.onRejected;
                        if (_cb == undefined)
                        {
                            if (__state == 1)
                            {
                                _deff.promise.__Resolve(__value);
                            }
                            else
                            {
                                _deff.promise.__Reject(__value);
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
                            _deff.promise.__Reject(_err);
                            return;
                        }
                        _deff.promise.__Resolve(_ret);
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
                    self.__state = 3;
                    self.__value = _newValue;
                    self.__Finale();
                    return;
                }
                
                var _then = _newValue[$ "Then"];
                if (is_method(_then))
                {
                    self.__DoResolve(method(_newValue, _then));
                    return;
                }
            }
            self.__state = 1;
            self.__value = _newValue;
            self.__Finale();
        }
        catch(_e)
        {
            self.__Reject(_newValue);
        }
    }
    
    static __Reject = function(_newValue)
    {
        self.__state = 2;
        self.__value = _newValue;
        self.__Finale();
    }
    
    static __Finale = function()
    {
        static _soon = __PromiseSystem().__soonArray;
        
        var _len = array_length(self.__deferreds);
        if ((self.__state == 2) && (_len == 0))
        {
            ds_list_add(_soon, function()
            {
                if (not self.__handled)
                {
                    show_debug_message($"Unhandled promise rejection: {__value}");
                }
            });
        }
        
        for (var _i = 0; _i < _len; _i++)
        {
            self.__Handle(self.__deferreds[_i]);
        }
        
        self.__deferreds = undefined;
    }
    
    self.__DoResolve(_handler);
}