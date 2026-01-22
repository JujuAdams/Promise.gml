function PromiseBracket(_scope, _initFunc, _finalFunc)
{
    with(_scope)
    {
        promise = PromiseCustom();
        
        __initializeFunc = method(self, _initFunc);
        __finalizeFunc   = method(self, _finalFunc);
        
        Promise(function(_resolve, _reject) { __initializeFunc(); _resolve(promise); })
        .Catch(function(_value) { return _value })
        .Finally(__finalizeFunc);
        
        return promise;
    }
    
    //var _promise = PromiseCustom();
    //
    //with({
    //    filename: _filename,
    //    promise:  _promise,
    //    buffer:   undefined,
    //})
    //{
    //    Promise(function(_resolve, _reject)
    //        {
    //            SparkleLoad(filename, function(_status, _buffer, _callbackMetadata)
    //            {
    //                buffer = _buffer;
    //
    //                if (_status)
    //                {
    //                    promise.Resolve(_buffer);
    //                }
    //                else
    //                {
    //                    promise.Reject(_buffer);
    //                }
    //            });
    //
    //            _resolve(promise);
    //        }
    //    ).Finally(
    //        function()
    //        {
    //            show_debug_message($"clearing up buffer {buffer}");
    //            
    //            if (buffer_exists(buffer))
    //            {
    //                buffer_delete(buffer);
    //                buffer = undefined;
    //            }
    //        }
    //    );
    //}
    //
    //return _promise;
}