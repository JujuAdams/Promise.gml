// Feather disable all

/// @param [handler]

function __PromiseClass(_handler) constructor
{
    __state         = __PROMISE_STATE_PENDING;
    __value         = undefined;
    __handled       = false;
    __deferredArray = [];
    
    __ExecuteHandler(_handler);
    
    
    
    static toString = function()
    {
        return $"Promise(state={__state}, value={__value}, deferred count={array_length(__deferredArray)})";
    }
    
    static Then = function(_onFulfilled, _onRejected = undefined)
    {
        // Create a deferred promise and add it to either our internal "deferred" array or the
        // global "soon" array
        
        var _deferred = new __PromiseClassDeferred(_onFulfilled, _onRejected);
        
        __HandleDeferred(_deferred);
        
        return _deferred.__promise;
    }
    
    static ThenReverse = function(_onRejected, _onFulfilled)
    {
        return Then(_onFulfilled, _onRejected);
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
                });
            },
            function(_value)
            {
                __value = _value;
                
                return PromiseResolve(__callback()).Then(function()
                {
                    return PromiseReject(__value);
                });
            })
        }
    }
    
    static __ExecuteHandler = function(_function)
    {
        if (not is_callable(_function))
        {
            return;
        }
        
        //Calls a function with two arguments: the "resolve" and "reject" callbacks. When the
        //function executes one of the callbacks, the scoped promise will then resolve/reject using
        //the returned value as appropriate.
        
        var _self = self;
        
        //Juju: Not entirely sure why we need to track `.done` here. Perhaps it's to catch bugs
        //      where a wonky function calls resolve/reject multiple times?
        with({
            __done: false,
            __self: _self,
        })
        {
            try
            {
                _function(function(_value)
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
            catch(_error)
            {
                if (__done) return;
                
                __done = true;
                _self.__Reject(_error);
            }
        }
    }
    
    static __HandleDeferred = function(_deferred)
    {
        static _soonArray = __PromiseSystem().__soonArray;
        
        //Add the deferred promise to the deffered array of the deepest non-passthrough promise
        var _target = self;
        while(_target.__state == __PROMISE_STATE_PASSTHROUGH)
        {
            _target = _target.__value;
        }
        
        //If the target promise hasn't completed then add the deferred struct to that promise's array
        if (_target.__state == __PROMISE_STATE_PENDING)
        {
            array_push(_target.__deferredArray, _deferred);
            return;
        }
        
        _target.__handled = true;
        
        array_push(_soonArray, method({
            __target:   _target,
            __deferred: _deferred,
        },
        function()
        {
            var _deferred = __deferred;
            with(__target)
            {
                var _callback = (__state == __PROMISE_STATE_FULFILLED)? _deferred.__onFulfilled : _deferred.__onRejected;
                if (is_callable(_callback))
                {
                    //Execute the callback found in the deferred struct and pass the returned value to its promise
                    var _return = undefined;
                    try
                    {
                        _return = _callback(__value);
                    }
                    catch(_error)
                    {
                        _deferred.__promise.__Reject(_error);
                        return;
                    }
                    
                    _deferred.__promise.__Resolve(_return);
                }
                else
                {
                    //The deferred struct itself has no function for the state so resolve/reject its promise
                    if (__state == __PROMISE_STATE_FULFILLED)
                    {
                        _deferred.__promise.__Resolve(__value);
                    }
                    else
                    {
                        _deferred.__promise.__Reject(__value);
                    }
                }
            }
        }));
    }
    
    static __Resolve = function(_newValue)
    {
        try
        {
            // Promise Resolution Procedure:
            // https://github.com/promises-aplus/promises-spec#the-promise-resolution-procedure
            if (_newValue == self)
            {
                show_error($"A promise cannot be resolved with itself", true);
            }
            
            if (is_struct(_newValue) || is_method(_newValue))
            {
                if (is_instanceof(_newValue, __PromiseClass))
                {
                    //If the return value is a promise, mark ourselves as passthrough and execute
                    //our deferred promises
                    __state = __PROMISE_STATE_PASSTHROUGH;
                    __value = _newValue;
                    __Finish();
                    return;
                }
                
                //Also allow structs that contain a `.Then` field to be executed
                //TODO - Can this be removed? What's the point of this?
                var _then = _newValue[$ "Then"];
                if (is_method(_then))
                {
                    __ExecuteHandler(method(_newValue, _then));
                    return;
                }
            }
            
            //We got a simple value in return, we're fulfilled and can finish
            __state = __PROMISE_STATE_FULFILLED;
            __value = _newValue;
            __Finish();
        }
        catch(_error)
        {
            __Reject(_error);
        }
    }
    
    static __Reject = function(_newValue)
    {
        __state = __PROMISE_STATE_REJECTED;
        __value = _newValue;
        __Finish();
    }
    
    static __Finish = function()
    {
        static _soonArray = __PromiseSystem().__soonArray;
        
        var _length = array_length(__deferredArray);
        
        //Show a warning if we don't have any deferred promises that might be able to catch a rejection
        if ((__state == __PROMISE_STATE_REJECTED) && (_length == 0))
        {
            array_push(_soonArray, function()
            {
                if (not __handled)
                {
                    if (PROMISE_WARN_UNHANDLED_REJECTION)
                    {
                        __PromiseTrace($"Warning! Unhandled promise rejection: {__value}");
                    }
                }
            });
        }
        
        var _i = 0;
        repeat(_length)
        {
            __HandleDeferred(__deferredArray[_i]);
            ++_i;
        }
        
        __deferredArray = undefined;
    }
}