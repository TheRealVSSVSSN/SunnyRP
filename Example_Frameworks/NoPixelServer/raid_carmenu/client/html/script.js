let open = false;
const carmenu = document.getElementById('carmenu');
carmenu.style.display = 'none';

function checkElement(settings, element, key) {
    const parent = element.parentElement;
    if (settings[key]) {
        parent.classList.add('active');
    } else {
        parent.classList.remove('active');
    }
}

function checkSeat(settings, element, key) {
    const parent = element.parentElement;
    parent.classList.remove('disabled', 'active');
    if (settings[key] === parseInt(element.getAttribute('value'), 10)) {
        parent.classList.add('active');
    } else if (settings[key] !== true) {
        parent.classList.add('active', 'disabled');
    }
}

window.addEventListener('message', (event) => {
    if (event.data.type === 'enablecarmenu') {
        open = event.data.enable;
        if (open) {
            document.body.style.display = 'block';
            carmenu.style.display = 'block';
            setTimeout(() => {
                carmenu.style.opacity = '1';
            }, 1);
        } else {
            carmenu.style.opacity = '0';
            setTimeout(() => {
                carmenu.style.display = 'none';
                document.body.style.display = 'none';
            }, 500);
        }
    }

    if (event.data.type === 'refreshcarmenu') {
        const settings = event.data.settings;
        document.querySelectorAll('.seat').forEach((el) => {
            const val = parseInt(el.getAttribute('value'), 10);
            if (val === -1) checkSeat(settings, el, 'seat1');
            if (val === 0) checkSeat(settings, el, 'seat2');
            if (val === 1) checkSeat(settings, el, 'seat3');
            if (val === 2) checkSeat(settings, el, 'seat4');
        });

        document.querySelectorAll('.door').forEach((el) => {
            const parent = el.parentElement;
            if (!settings.doorAccess) {
                parent.classList.add('disabled');
            } else {
                parent.classList.remove('disabled');
            }
            const val = parseInt(el.getAttribute('value'), 10);
            if (val === 0) checkElement(settings, el, 'door0');
            if (val === 1) checkElement(settings, el, 'door1');
            if (val === 2) checkElement(settings, el, 'door2');
            if (val === 3) checkElement(settings, el, 'door3');
            if (val === 4) checkElement(settings, el, 'hood');
            if (val === 5) checkElement(settings, el, 'trunk');
        });

        document.querySelectorAll('.window').forEach((el) => {
            const val = parseInt(el.getAttribute('value'), 10);
            if (val === 0) checkElement(settings, el, 'windowr1');
            if (val === 1) checkElement(settings, el, 'windowl1');
            if (val === 2) checkElement(settings, el, 'windowr2');
            if (val === 3) checkElement(settings, el, 'windowl2');
        });

        const engineParent = document.querySelector('.engine').parentElement;
        engineParent.classList.toggle('active', settings.engine === true);
    }
});

function post(url, data) {
    fetch(`https://raid_carmenu/${url}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data || {})
    });
}

document.querySelectorAll('.door').forEach((el) => {
    el.addEventListener('click', () => {
        if (el.parentElement.classList.contains('disabled')) return;
        post('openDoor', { doorIndex: el.getAttribute('value') });
    });
});

document.querySelectorAll('.seat').forEach((el) => {
    el.addEventListener('click', () => {
        post('switchSeat', { seatIndex: el.getAttribute('value') });
    });
});

document.querySelectorAll('.window').forEach((el) => {
    el.addEventListener('click', () => {
        post('togglewindow', { windowIndex: el.getAttribute('value') });
    });
});

document.querySelectorAll('.engine').forEach((el) => {
    el.addEventListener('click', () => {
        if (el.parentElement.classList.contains('disabled')) return;
        post('toggleengine');
    });
});

document.addEventListener('keyup', (data) => {
    if (open && (data.which === 90 || data.which === 27)) {
        post('escape');
    }
});
