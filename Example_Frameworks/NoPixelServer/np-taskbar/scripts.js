document.addEventListener('DOMContentLoaded', () => {
    const wrapper = document.querySelector('.divwrap');
    const progressBar = document.getElementById('progress-bar');
    const label = document.querySelector('.nicesexytext');
    let curTask = null;

    const openMain = (taskName, taskId) => {
        wrapper.style.display = 'block';
        progressBar.style.width = '0%';
        label.textContent = taskName;
        curTask = taskId;
    };

    const closeMain = () => {
        wrapper.style.display = 'none';
    };

    window.addEventListener('message', (event) => {
        const item = event.data;

        if (item.runProgress) {
            openMain(item.name, item.Task);
        }

        if (item.runUpdate) {
            progressBar.style.width = `${item.Length}%`;
            label.textContent = item.name;
            curTask = item.Task;
        }

        if (item.closeFail) {
            closeMain();
            fetch('https://np-taskbar/taskCancel', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ tasknum: curTask })
            });
        }

        if (item.closeProgress) {
            closeMain();
        }
    });
});

