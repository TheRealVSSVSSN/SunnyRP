/*
    -- Type: Script
    -- Name: index.js
    -- Use: Handles scoreboard rendering from Lua messages
    -- Created: 2024-05-06
    -- By: VSSVSSN
*/

window.addEventListener('message', (event) => {
    const data = event.data;
    const playerList = document.getElementById('plys');
    const container = document.querySelector('.fsn_playerlist');
    const copyright = document.querySelector('.fsn_copyright');

    if (data.type === 'show' && Array.isArray(data.players)) {
        document.querySelectorAll('[data-player-row]').forEach(el => el.remove());

        data.players.forEach((p) => {
            const row = document.createElement('tr');
            row.setAttribute('data-player-row', 'true');
            row.innerHTML = `
                <td class="id">${p.ply_id}</td>
                <td class="rpname">${p.char_name}</td>
                <td class="steamname">${p.ply_name}</td>
                <td class="accesslevel">User</td>
            `;
            playerList.appendChild(row);
        });

        container.style.display = 'block';
        copyright.style.display = 'block';
    } else if (data.type === 'hide') {
        container.style.display = 'none';
        copyright.style.display = 'none';
    }
});
