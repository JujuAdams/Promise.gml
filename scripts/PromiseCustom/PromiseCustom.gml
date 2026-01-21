// Feather disable all

/// Creates a promise with exposed resolve and reject functions. This sort of promise can be used
/// more easily with other GameMaker features, especially native Asunc Events. When you'd like to
/// pass a value back into a promise, call either of the following two functions:
/// 
/// .Resolve(value)
///     Passes the value back into the promise as a successful operation.
/// 
/// .Reject(value)
///     Passes the value back into the promise as a failed operation.
/// 
/// N.B. You will only be able to call either of these functions once and the functions are
///      mutually exclusive.

function PromiseCustom()
{
    return new __PromiseClassCustom();
}