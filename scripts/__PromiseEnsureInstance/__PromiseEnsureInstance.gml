// Feather disable all

function __PromiseEnsureInstance()
{
    if (not instance_exists(__PromiseObject))
    {
        instance_create_depth(0, 0, 0, __PromiseObject);
    }
}