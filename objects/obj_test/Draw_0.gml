numButtons = 0;

var button = function(name)
{
    draw_text(10, 10 + 30 * numButtons, "[" + string(numButtons + 1) + "]: " + name);
    return keyboard_check_pressed(ord("1") + numButtons++);
}

if (button("Chain"))
{
    Promise(
        function(done, fail)
        {
            setTimeout(function(_done, _fail)
            {
                if (0) _done("hello!"); else _fail("bye!");
            },
            1000, done, fail);
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
            setTimeout(_resolve, 100, "foo");
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
            setTimeout(_reject, 100, "drats");
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
        Promise(
            function(_resolve, _reject)
            {
                setTimeout(_resolve, 500, "one");
            }
        ),
        Promise(
            function(_resolve, _reject)
            {
                setTimeout(_resolve, 100, "two");
            }
        ),
    ]).Then(
        function(_value)
        {
            show_debug_message(_value);
        }
    );
}

if (button("HTTP requests"))
{
    http_get_promise("https://yal.cc/ping").Then(
        function(_value)
        {
            show_debug_message($"success {_value}");
            return http_get_promise("https://yal.cc/ping");
        }
    ).Then(
        function(_value)
        {
            show_debug_message($"success2 {_value}");
        }
    ).Catch(
        function(_value)
        {
            show_debug_message($"failed {_value}");
        }
    );
}

if (button("messages"))
{
    with({ ip: "", port: "", alias: "" })
    {
        get_string_promise("IP?", "127.0.0.1").Then(
            function(_ip)
            {
                ip = _ip;
                return get_string_promise("Port?", "5394");
            }
        ).Then(
            function(_port)
            {
                port = _port;
                return get_string_promise("Alias?", "Me");
            }
        ).Then(
            function(_alias)
            {
                alias = _alias;
                show_debug_message([ip, port, alias]);
            }
        ).Catch(
            function(e)
            {
                show_debug_message("Cancelled!");
            }
        );
    }
}