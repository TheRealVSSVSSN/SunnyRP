/*
    Type: NUI Script
    Name: ui.js
    Use: Handles evidence locker UI logic
    Created: 2024-06-06
    By: VSSVSSN
*/

(function () {
    const actionMenu = document.getElementById('actionmenu');
    const inventory = document.getElementById('inventory');

    window.addEventListener('message', (event) => {
        const data = event.data;
        if (data.showmenu) {
            actionMenu.style.display = 'block';
        }
        if (data.hidemenu) {
            actionMenu.style.display = 'none';
            inventory.style.display = 'none';
        }
        if (data.inventory) {
            inventory.innerHTML = '';
            data.inventory.forEach(item => {
                const div = document.createElement('button');
                div.className = 'menuoption';
                div.textContent = item.description;
                inventory.appendChild(div);
            });
            inventory.style.display = 'block';
        }
    });

    const sendData = (action) => {
        fetch(`https://fsn_storagelockers/ButtonClick`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(action)
        });
    };

    document.querySelectorAll('.menuoption').forEach(btn => {
        btn.addEventListener('click', () => {
            const action = btn.dataset.action;
            if (action) {
                sendData(action);
            }
        });
    });
})();

