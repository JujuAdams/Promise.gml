# This is a fork of [YellowAfterlife's work](https://github.com/YAL-GameMaker/Promise.gml)

&nbsp;

# Promise.gml
An adaptation of JavaScript
[Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
for GameMaker Studio 2024.14, based on [this polyfill](https://github.com/taylorhakes/promise-polyfill).

## JS➜GML Equivalents

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

## Changes

GameMaker does not allow naming methods same as keywords, therefore:

- `then` ➜ `Then`
- `catch` ➜ `Catch`
- `finally` ➜ `Finally`
- `all` ➜ `All`

## Examples

Can also be found in the sample project, along with supporting scripts.

Basic (ft. custom setTimeout):
```gml
Promise(
	function(done, fail) {
		setTimeout(
		function(_done, _fail) {
			if (random(2) >= 1) _done("hello!"); else _fail("bye!");
		},
		250, done, fail);
	}
).Then(
	function(_val) {
		trace("resolved!", _val);
	},
	function(_val) {
		trace("failed!", _val);
	}
);
```

afterAll:
```gml
PromiseAll([
	PromiseResolve(3),
	42,
	Promise(
		function(resolve, reject) {
			setTimeout(resolve, 100, "foo");
		}
	)
]).Then(
	function(values) {
		trace(values);
	}
);
```

Chaining HTTP requests (ft. custom HTTP wrappers):
```gml
http_get_promise("https://yal.cc/ping").Then(
	function(v) {
		trace("success", v);
		return http_get_promise("https://yal.cc/ping");
	}
).Then(
	function(v) {
		trace("success2", v);
	}
).Catch(
	function(e) {
		trace("failed", e);
	}
);
```

## Caveats

* Non-exact naming (but feel free to pick your own aliases).
* Have to "promisify" built-in functions to be able to finely use them with promises.
* I could not port the original JS library's unit tests because their dependencies have far more code than the library itself.
