// Feather disable all

function SparkleLoad(_filename, _callback)
{
    static _buffer = 0;
    --_buffer;
    
    call_later_ext(1000, _callback, [true, _buffer, undefined]);
}