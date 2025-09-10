const resourceName = GetCurrentResourceName();

/*
    -- Type: Function
    -- Name: runJS
    -- Use: Executes arbitrary JavaScript in the resource context.
    -- Created: 2025-09-10
    -- By: VSSVSSN
*/
exports('runJS', (snippet) => {
    if (IsDuplicityVersion() && GetInvokingResource() !== resourceName) {
        return [ 'Invalid caller.', false ];
    }

    try {
        return [ new Function(String(snippet))(), false ];
    } catch (e) {
        return [ false, e.toString() ];
    }
});