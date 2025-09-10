let progressInterval = null;
let ellipsisInterval = null;

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.type !== 'progressBar') return;

    const body = document.body;
    const bar = document.getElementById('progress');
    const title = document.getElementById('fsn_title');
    const ellipsis = document.getElementById('fsn_ellipsis');

    if (data.display) {
        body.style.display = 'block';
        bar.style.width = '0%';
        bar.style.backgroundColor = `rgb(${data.color.r}, ${data.color.g}, ${data.color.b})`;
        title.textContent = data.title;
        ellipsis.textContent = '';

        let elapsed = 0;
        const duration = data.duration;

        if (progressInterval) clearInterval(progressInterval);
        progressInterval = setInterval(() => {
            elapsed += 50;
            const pct = Math.min((elapsed / duration) * 100, 100);
            bar.style.width = pct + '%';
            if (pct >= 100) {
                clearInterval(progressInterval);
                clearInterval(ellipsisInterval);
                body.style.display = 'none';
                bar.style.width = '0%';
                ellipsis.textContent = '';
            }
        }, 50);

        if (ellipsisInterval) clearInterval(ellipsisInterval);
        ellipsisInterval = setInterval(() => {
            ellipsis.textContent = ellipsis.textContent.length >= 3 ? '' : ellipsis.textContent + '.';
        }, 500);
    } else {
        if (progressInterval) clearInterval(progressInterval);
        if (ellipsisInterval) clearInterval(ellipsisInterval);
        body.style.display = 'none';
        bar.style.width = '0%';
        ellipsis.textContent = '';
    }
});

