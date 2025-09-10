/*
    -- Type: Script
    -- Name: scripts.js
    -- Use: Handles NUI interactions for CID creation
    -- Created: 2024-09-10
    -- By: VSSVSSN
*/

(() => {
    const resourceName = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'np-cid';
    const container = document.querySelector('.phone-container');
    const submitBtn = document.getElementById('sigh');

    const post = (endpoint, data) => {
        fetch(`https://${resourceName}/${endpoint}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(data)
        });
    };

    const openContainer = () => {
        container.style.display = 'block';
    };

    const closeContainer = () => {
        container.style.display = 'none';
    };

    const attemptCompletion = () => {
        const first = document.getElementById('first').value.trim();
        const last = document.getElementById('last').value.trim();
        const job = document.getElementById('job').value.trim();
        const sex = document.getElementById('sex').value.trim();
        const dob = document.getElementById('dob').value.trim();

        let failureMessage = '';

        if (!first) failureMessage = 'You must input a first name';
        else if (!last) failureMessage = 'You must input a last name';
        else if (!job) failureMessage = 'You must input a job';
        else if (!sex) failureMessage = 'You must input sex';
        else if (!dob) failureMessage = 'You must input a DOB';

        if (failureMessage) {
            post('error', { message: failureMessage });
        } else {
            post('create', { first, last, job, sex, dob });
        }
    };

    submitBtn.addEventListener('click', attemptCompletion);

    window.addEventListener('message', (event) => {
        const item = event.data;
        if (item.openPhone === true) openContainer();
        if (item.openPhone === false) closeContainer();
    });

    document.addEventListener('keyup', (e) => {
        if (e.key === 'Escape') {
            post('close', {});
        }
    });
})();
