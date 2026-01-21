numButtons = 0;

var button = function(name)
{
    draw_text(10, 10 + 30 * numButtons, "[" + string(numButtons + 1) + "]: " + name);
    return keyboard_check_pressed(ord("1") + numButtons++);
}

if (button("Chain"))
{
    Promise(
        function(_resolve, _reject)
        {
            if (random(1))
            {
                return _resolve("hello");
            }
            else
            {
                return _reject("goodbye");
            }
        }
    ).Then(
        function(_value)
        {
            show_debug_message($"resolved! {_value}");
        },
        function(_value)
        {
            show_debug_message($"failed! {_value}");
        }
    ).Finally(
        function()
        {
            show_debug_message("finally!");
        }
    );
}

if (button("All()"))
{
    PromiseAll([
        PromiseResolve(3),
        42,
        Promise(function(_resolve, _reject)
        {
            call_later_ext(200, _resolve, "foo");
        })
    ]).Then(
        function(_values)
        {
            show_debug_message(_values);
        }
    );
}

if (button("AllSettled()"))
{
    PromiseAllSettled([
        PromiseResolve(3),
        42,
        Promise(function(_resolve, _reject)
        {
            call_later_ext(200, _reject, "drats");
        })
    ]).Then(
        function(_values)
        {
            show_debug_message(_values);
        }
    );
}

if (button("Race()"))
{
    PromiseRace([
        PromiseDelay(500, "one"),
        PromiseDelay(100, "two"),
    ]).Then(
        function(_value)
        {
            show_debug_message(_value);
        }
    );
}

if (button("HTTP requests"))
{
    Promise_http_get("https://yal.cc/ping").Then(
        function(_value)
        {
            show_debug_message($"success {json_stringify(_value.result)}");
            return Promise_http_get("https://yal.cc/ping");
        }
    ).Then(
        function(_value)
        {
            show_debug_message($"success2 {json_stringify(_value.result)}");
        }
    ).Catch(
        function(_value)
        {
            show_debug_message($"failed {json_stringify(_value.result)}");
        }
    );
}

if (button("messages"))
{
    with({ ip: "", port: "", alias: "" })
    {
        Promise_get_string_async("IP?", "127.0.0.1").Then(
            function(_asyncStruct)
            {
                ip = _asyncStruct.result;
                return Promise_get_string_async("Port?", "5394");
            }
        ).Then(
            function(_asyncStruct)
            {
                port = _asyncStruct.result;
                return Promise_get_string_async("Alias?", "Me");
            }
        ).Then(
            function(_asyncStruct)
            {
                alias = _asyncStruct.result;
                show_debug_message([ip, port, alias]);
            }
        ).Catch(
            function(_error)
            {
                show_debug_message("Cancelled!");
            }
        );
    }
}

if (button("timeout"))
{
    PromiseTimeout(500, undefined, function(){}).Then(
        function()
        {
            show_debug_message("This should never appear");
        },
        function()
        {
            show_debug_message("failure (which is expected)");
        }
    );
}