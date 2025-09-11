//[
//  Type: Event Listener
//  Name: message
//  Use: Toggles crafting NUI visibility
//  Created: 2024-10-29
//  By: VSSVSSN
//]

window.addEventListener('message', function (event) {
    if (event.data && event.data.action === 'display') {
        document.body.style.display = event.data.toggle ? 'block' : 'none';
    }
});

