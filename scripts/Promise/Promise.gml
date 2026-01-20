// Feather disable all

/// @param handler

function Promise(_handler)
{
    if (not is_callable(_handler))
    {
        show_error("Not a function", true);
    }
    
    return new __PromiseClass(_handler);
}