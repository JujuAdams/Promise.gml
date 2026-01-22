// Feather disable all

/// @param filename
/// @param forceState

function PromiseBuffer(_filename, _forceState)
{
    return PromiseBracket(
        {
            filename: _filename,
            buffer: undefined,
            forceState: _forceState,
        },
        function()
        {
            SparkleLoad(filename, function(_status, _buffer, _callbackMetadata)
            {
                buffer = _buffer;
            
                if (forceState)
                {
                    promise.Resolve(-_buffer);
                }
                else
                {
                    promise.Reject(_buffer);
                }
            });
        },
        function()
        {
            show_debug_message($"clearing up buffer {buffer}");
            
            if (buffer_exists(buffer))
            {
                buffer_delete(buffer);
                buffer = undefined;
            }
        },
    );
}