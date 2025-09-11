let weapons = [];
let inventory = [];

const actionMenu = document.getElementById('actionmenu');

document.addEventListener('DOMContentLoaded', () => {
    init();
    window.addEventListener('message', (event) => {
        const item = event.data;
        if (item.showmenu) {
            ResetMenu();
            weapons = JSON.parse(item.weapons);
            actionMenu.style.display = 'block';
        }
        if (item.hidemenu) {
            actionMenu.style.display = 'none';
        }
    });
});

function ResetMenu() {
    document.querySelectorAll('[data-parent]').forEach(el => {
        el.style.display = 'none';
    });
    document.querySelectorAll('#actionmenu > div:not([data-parent])').forEach(el => {
        el.style.display = 'block';
    });
}

function parseWeapons() {
    const weaponsDiv = document.getElementById('weapons');
    weaponsDiv.innerHTML = '';
    document.querySelectorAll('[data-spawn="weapon"]').forEach(el => el.remove());
    document.getElementById('exitbutton').remove();
    weapons.forEach((val, i) => {
        weaponsDiv.insertAdjacentHTML('beforeend', `<button class="menuoption" data-sub="${i}" data-spawn="weapon">${val.name}</button>`);
        actionMenu.insertAdjacentHTML('beforeend', `<div id="${i}" data-parent="mainmenu" style="display:none" data-spawn="weapon"><button class="menuoption" data-action="wepmenu-info-${i}" data-spawn="weapon">View Info</button><button class="menuoption" data-action="wepmenu-equip-${i}" data-spawn="weapon">Equip</button></div>`);
    });
    weaponsDiv.insertAdjacentHTML('afterbegin', '<button class="menuoption" data-action="weapon-putaway" data-spawn="weapon"><b>Store Weapon</b></button>');
    actionMenu.insertAdjacentHTML('beforeend', '<button id="exitbutton" class="menuoption" data-action="exit">Exit</button>');
    init();
}

function parseItems(items) {
    // placeholder for future inventory UI
}

function init() {
    document.querySelectorAll('.menuoption').forEach(btn => {
        btn.onclick = null;
        if (btn.dataset.action) {
            btn.addEventListener('click', () => {
                const data = btn.dataset.action;
                const parts = data.split('-');
                if (parts[0] === 'wepmenu' && parts[1] === 'info') {
                    sendData('weaponInfo', weapons[parseInt(parts[2], 10)]);
                } else if (parts[0] === 'wepmenu' && parts[1] === 'equip') {
                    sendData('weaponEquip', weapons[parseInt(parts[2], 10)]);
                } else if (data === 'takeItem') {
                    sendData('inventoryTake', btn.dataset.item);
                } else {
                    sendData('ButtonClick', data);
                }
            });
        }
        if (btn.dataset.sub) {
            btn.addEventListener('click', () => {
                const menu = btn.dataset.sub;
                const element = document.getElementById(menu);
                element.style.display = 'block';
                btn.parentElement.style.display = 'none';
                if (menu === 'weapons') {
                    parseWeapons();
                }
                if (menu === 'inventory') {
                    parseItems(inventory);
                }
            });
        }
    });
}

function sendData(name, data) {
    fetch(`https://fsn_apartments/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data)
    }).then(resp => resp.text()).then(resp => {
        if (resp !== 'ok') {
            console.log(resp);
        }
    });
}

document.onkeyup = function (data) {
    if (data.key === 'Escape') {
        sendData('escape', {});
    }
};

