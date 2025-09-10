document.addEventListener('DOMContentLoaded', () => {
    const cursor = document.getElementById('cursor');
    let cursorX = document.documentElement.clientWidth / 2;
    let cursorY = document.documentElement.clientHeight / 2;

    function updateCursorPos() {
        cursor.style.left = `${cursorX + 2}px`;
        cursor.style.top = `${cursorY + 2}px`;
    }

    function openMain() {
        document.querySelector('.home').style.display = 'block';
        document.querySelector('.contract-container').style.display = 'block';
        cursor.style.display = 'block';
    }

    function closeMain() {
        document.querySelector('.home').style.display = 'none';
        document.querySelector('.contract-container').style.display = 'none';
        cursor.style.display = 'none';
    }

    document.querySelector('.btnSubmit').addEventListener('click', () => {
        fetch('https://np-gurgle/btnSubmit', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({
                websiteName: document.querySelector('.contractID').value,
                websiteKeywords: document.querySelector('.contractAmount').value,
                websiteDescription: document.querySelector('.contractInfo').value
            })
        });
    });

    window.addEventListener('message', (event) => {
        const item = event.data;
        if (item.openSection === 'openGurgle') {
            openMain();
        } else if (item.openSection === 'closeGurgle') {
            closeMain();
        }
    });

    document.addEventListener('mousemove', (event) => {
        cursorX = event.pageX;
        cursorY = event.pageY;
        updateCursorPos();
    });

    document.addEventListener('keyup', (event) => {
        if (event.key === 'Escape') {
            fetch('https://np-gurgle/close', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                body: '{}'
            });
        }
    });
});
