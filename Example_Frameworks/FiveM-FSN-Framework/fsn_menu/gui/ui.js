/*--------------------------------------------------------------------------

    ActionMenu - Vanilla JS rewrite
    Original by WolfKnight

--------------------------------------------------------------------------*/
let atstorage = false;

document.addEventListener('DOMContentLoaded', () => {
    const actionContainer = document.getElementById('actionmenu');

    window.addEventListener('message', (event) => {
        const item = event.data;
        if (item.showmenu) {
            resetMenu();
            actionContainer.style.display = 'block';
            atstorage = !!item.atstorage;

            toggle('vehiclebutton', item.vehicle);
            toggle('policebutton', item.police);
            toggle('pdcommandbutton', item.pdcommand && item.police);
            toggle('emsbutton', item.ems);
            toggle('emscommandbutton', item.emscommand && item.ems);

            if (item.dead) {
                ['phonebutton','licensebutton','inventorybutton','vehiclebutton','policebutton','pdcommandbutton','emsbutton','emscommandbutton'].forEach(id => toggle(id,false));
            } else {
                ['phonebutton','licensebutton','inventorybutton'].forEach(id => toggle(id,true));
            }
        }

        if (item.hidemenu) {
            actionContainer.style.display = 'none';
        }
        init();
    });
});

function toggle(id, state) {
    const el = document.getElementById(id);
    if (el) { el.style.display = state ? 'block' : 'none'; }
}

function resetMenu() {
    document.querySelectorAll('div').forEach(el => {
        if (el.dataset.parent) {
            el.style.display = 'none';
        } else {
            el.style.display = 'block';
        }
    });
}

function init() {
    document.querySelectorAll('.menuoption').forEach(el => {
        if (!el.dataset.bound) {
            if (el.dataset.action) {
                el.addEventListener('click', () => sendData('ButtonClick', el.dataset.action));
            }
            if (el.dataset.sub) {
                el.addEventListener('click', () => {
                    const menu = document.getElementById(el.dataset.sub);
                    if (menu) {
                        menu.style.display = 'block';
                        el.parentElement.style.display = 'none';
                    }
                });
            }
            el.dataset.bound = 'true';
        }
    });
}

function sendData(name, data) {
    fetch(`https://fsn_menu/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data)
    }).catch(e => console.log(e));
}

document.addEventListener('keyup', (data) => {
    if (data.key === 'Escape') {
        fetch('https://fsn_menu/escape', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: '{}'
        });
    }
});
