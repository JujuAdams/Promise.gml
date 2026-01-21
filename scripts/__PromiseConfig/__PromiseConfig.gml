// Feather disable all

// Whether to output warning for unhandled rejections to the output log. The default value
// `PROMISE_RUNNING_FROM_IDE` will cause the warnings to only appear when running from the IDE.
#macro PROMISE_WARN_UNHANDLED_REJECTION  PROMISE_RUNNING_FROM_IDE

// Whether to show verbose HTTP error messages in the output log when `Promise_http_get()` etc.
// fail. This might potentially leak sensitive data so the default value ensure that no exceptions
// are disclosed in production builds. You may want to set this value to `true` for QA builds.
#macro PROMISE_VERBOSE_HTTP_ERRORS  PROMISE_RUNNING_FROM_IDE

// How often to check if `PromiseCustom()` promises have fallen out of scope.
#macro PROMISE_SCOPE_TEST_PERIOD  0.5 //seconds