// Feather disable all

/// @param milliseconds
/// @param function
/// @param argumentArray

function call_later_ext(_milliseconds, _function, _argumentArray)
{
    if (not is_array(_argumentArray))
    {
        _argumentArray = [_argumentArray];
    }
    
    call_later(_milliseconds/1000, time_source_units_seconds, method({
        __function: _function,
        __argumentArray: _argumentArray,
    },
    function()
    {
        method_call(__function, __argumentArray);
    }));
}