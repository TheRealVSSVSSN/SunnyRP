/*
 * Type: Listener
 * Name: NUI Message Handler
 * Use: Processes notifications and queue settings from Lua
 * Created: 2025-09-10
 * By: VSSVSSN
 */
window.addEventListener('DOMContentLoaded', function () {
  window.addEventListener('message', function (event) {
    if (event.data.options) {
      new Noty(event.data.options).show();
    } else if (event.data.maxNotifications) {
      const max = event.data.maxNotifications;
      Noty.setMaxVisible(max.max, max.queue);
    }
  });
});
