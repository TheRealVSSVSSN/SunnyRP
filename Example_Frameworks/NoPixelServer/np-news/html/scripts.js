document.addEventListener('DOMContentLoaded', () => {
    const cursor = document.getElementById('cursor');
    const home = document.querySelector('.home');
    const newsContainer = document.querySelector('.news-container');
    const listOne = document.querySelector('.lstNews');
    const listTwo = document.querySelector('.lstNews2');

    document.addEventListener('mousemove', (event) => {
        cursor.style.left = `${event.pageX + 10}px`;
        cursor.style.top = `${event.pageY + 10}px`;
    });

    window.addEventListener('message', (event) => {
        const item = event.data;
        if (item.openSection === 'newsUpdate') {
            home.style.display = 'block';
            newsContainer.style.display = 'block';
            listOne.style.display = 'block';
            listTwo.style.display = 'block';
            listOne.innerHTML = item.string || '';
            listTwo.innerHTML = item.string2 || '';
            cursor.style.display = 'block';
        }

        if (item.openSection === 'close') {
            home.style.display = 'none';
            newsContainer.style.display = 'none';
            cursor.style.display = 'none';
        }
    });

    window.addEventListener('keyup', (event) => {
        if (event.key === 'Escape') {
            fetch('https://np-news/close', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: '{}'
            });
        }
    });
});
