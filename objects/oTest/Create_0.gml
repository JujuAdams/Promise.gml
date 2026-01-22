numButtons = 0;
testScope = undefined;

PromiseBuffer("test.txt", true).ThenReverse(function(_value)
    {
        show_debug_message($"first PromiseBuffer {_value} failed");
        return _value;
    },
    function(_value)
    {
        show_debug_message($"first PromiseBuffer {_value} succeeded");
        
        return PromiseBuffer("test.txt", false).ThenReverse(function(_value)
            {
                show_debug_message($"second PromiseBuffer {_value} failed");
                return _value;
            },
            function(_value)
            {
                show_debug_message($"second PromiseBuffer {_value} succeeded");
                
                return PromiseBuffer("test.txt", true).ThenReverse(function(_value)
                    {
                        show_debug_message($"third PromiseBuffer {_value} failed");
                        return _value;
                    },
                    function(_value)
                    {
                        show_debug_message($"third PromiseBuffer {_value} succeeded");
                        show_debug_message("all PromiseBuffer succeeded");
                    }
                );
            }
        );
    }
).Catch(function(_value)
    {
        show_debug_message($"failed on PromiseBuffer {_value}");
    }
).Finally(function()
    {
        show_debug_message("done");
    }
);