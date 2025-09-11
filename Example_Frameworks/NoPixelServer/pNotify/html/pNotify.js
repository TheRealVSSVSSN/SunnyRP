document.addEventListener('DOMContentLoaded', () => {
    window.addEventListener('message', (event) => {
        if (event.data.options) {
            new Noty(event.data.options).show();
        } else {
            const maxNotifications = event.data.maxNotifications;
            Noty.setMaxVisible(maxNotifications.max, maxNotifications.queue);
        }
    });
});
