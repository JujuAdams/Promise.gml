// Feather disable all

function __PromiseEnsureInstance()
{
    if (not instance_exists(__PromiseObject))
    {
        instance_activate_object(__PromiseObject);
        
        if (instance_exists(__PromiseObject))
        {
            if (PROMISE_RUNNING_FROM_IDE)
            {
                __PromiseError("`__PromiseObject` must never be destroyed or deactivated");
            }
            else
            {
                __PromiseTrace("Warning! `__PromiseObject` must never be destroyed or deactivated");
            }
        }
        else
        {
            instance_create_depth(0, 0, 0, __PromiseObject);
            
            if (not instance_exists(__PromiseObject))
            {
                __PromiseError("Failed to create `__PromiseObject`\nThis usually happens if Promise.gml code is executed in global scope on boot");
            }
        }
    }
    else
    {
        if (not __PromiseObject.persistent)
        {
            if (PROMISE_RUNNING_FROM_IDE)
            {
                __PromiseError("`__PromiseObject` always be persistent");
            }
            else
            {
                __PromiseObject.persistent = true;
                __PromiseTrace("Warning! `__PromiseObject` must always be persistent");
            }
        }
    }
}