<h1 align="center">Promise.gml 1.2.0</h1>

<p align="center">JS Promises for GameMaker 2024.14</p>

<p align="center"><a href="https://github.com/JujuAdams/Promise.gml/releases/">Download the .yymps</a></p>

&nbsp;

## Authorship

This library is "made" by me, Juju Adams, but it is heavily based on prior work by [YellowAfterlife](https://github.com/YAL-GameMaker/Promise.gml). His work is, in turn, based on a JS Promise polyfill by [Taylor Hakes](https://github.com/taylorhakes/promise-polyfill).

&nbsp;

## JS ➜ GML Equivalents

GameMaker does not allow using built-in function names as variable names, so:

- [new Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) ➜ `Promise()`
- [promise.then](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/then) ➜ `PromiseThen()`
- [promise.catch](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/catch) ➜ `PromiseCatch()`
- [promise.finally](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/finally) ➜ `PromiseFinally()`
- [Promise.all](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all) ➜ `PromiseAll()`
- [Promise.allSettled](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/allSettled) ➜ `PromiseAllSettled()`
- [Promise.any](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/any) ➜ `PromiseAny()`
- [Promise.race](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/race) ➜ `PromiseRace()`
- [Promise.reject](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/race) ➜ `PromiseReject()`
- [Promise.resolve](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/resolve) ➜ `PromiseResolve()`

GameMaker also does not allow naming methods same as keywords, therefore:

- `.then` ➜ `.Then`
- `.catch` ➜ `.Catch`
- `.finally` ➜ `.Finally`
- `.all` ➜ `.All`

&nbsp;

## Extra Promise Types

I found it helpful to create some new promise types to make the library easier to work with. `PromiseTimeout()` and `PromiseDelay()` will wait an amount of real time before completing the promise (rejection in the case of `PromiseTimeout()`, resolve in the case of `PromiseDelay()`).

To make integration with native GameMaker code easier, I added `PromiseCustom()` which exposes the resolve and reject functions as public methods. You should call these functions with the return value when whatever process you're doing has completed. You can get a promise made with `PromiseCustom()` track a particular scope (a struct or an instance) to ensure that promises always fire off even if your game does something unexpected.

&nbsp;

## Examples

Can also be found in the sample project, along with supporting scripts.

### Basic

Featuring a custom [`call_later_ext()`](https://github.com/JujuAdams/Promise.gml/blob/master/scripts/call_later_ext/call_later_ext.gml).

```gml
Promise(
	function(_resolve, _reject) {
	    if (random(1)) {
			call_later_ext(250, _resolve, "hello!");
	    } else {
			call_later_ext(250, _reject, "bye!");
	    }
	}
).Then(
	function(_value) {
		trace("resolved!", _value);
	},
	function(_value) {
		trace("failed!", _value);
	}
);
```

### `PromiseAll()`

```gml
PromiseAll([
	PromiseResolve(3),
	42,
	Promise(
		function(_resolve, _reject) {
		    call_later_ext(100, _resolve, "hello!");
		}
	)
]).Then(
	function(_values) {
		trace(_values);
	}
);
```

### Chaining HTTP requests

```gml
Promise_http_get("https://yal.cc/ping").Then(
	function(_value) {
		show_debug_message($"success = {_value.result}");
		return Promise_http_get("https://yal.cc/ping");
	}
).Then(
	function(_value) {
		show_debug_message($"success2 = {_value.result}");
	}
).Catch(
	function(_error) {
		show_debug_message($"failed = {_error}");
	}
);
```

&nbsp;

## Caveats

- PascalCase naming which is not to everyone's taste
- Have to "promisify" built-in functions, but made easier by `PromiseCustom()`
- Original JS library's unit tests have not been ported
