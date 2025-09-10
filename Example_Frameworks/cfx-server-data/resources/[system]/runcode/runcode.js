exports('runJS', (snippet) => {
    if (IsDuplicityVersion() && GetInvokingResource() !== GetCurrentResourceName()) {
        return ['Invalid caller.', false];
    }

    try {
        // eslint-disable-next-line no-new-func
        return [new Function(snippet)(), false];
    } catch (e) {
        return [false, e.toString()];
    }
});

