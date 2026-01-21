// Feather disable all

/// @param handler

function Promise(_handler)
{
    if (not is_callable(_handler))
    {
        show_error($"Promises must be created using a function/method for the handler (typeof=\"{_handler}\")", true);
    }
    
    return new __PromiseClass(_handler);
}