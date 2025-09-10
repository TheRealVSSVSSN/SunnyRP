/**
 * Type: Client Script
 * Name: loadscreen.js
 * Use: Handles loading screen events and progress bar updates.
 * Created: 2024-02-14
 * By: VSSVSSN
 */

(() => {
    'use strict';

    let count = 0;
    let current = 0;

    const emojis = {
        INIT_BEFORE_MAP_LOADED: ['🍉'],
        INIT_AFTER_MAP_LOADED: ['🍋', '🍊'],
        INIT_SESSION: ['🍐', '🍅', '🍆']
    };

    const elements = {
        progress: document.querySelector('.thingy'),
        status: document.querySelector('.letni h3'),
        message: document.querySelector('.letni p')
    };

    const handlers = {
        startInitFunctionOrder: data => {
            count = data.count;
            const symbol = emojis[data.type]?.[data.order - 1] || '';
            elements.status.textContent += symbol;
        },

        initFunctionInvoking: data => {
            elements.progress.style.left = '0%';
            elements.progress.style.width = `${(data.idx / count) * 100}%`;
        },

        startDataFileEntries: data => {
            count = data.count;
            elements.status.textContent += '🍘';
        },

        performMapLoadFunction: () => {
            current++;
            elements.progress.style.left = '0%';
            elements.progress.style.width = `${(current / count) * 100}%`;
        },

        onLogLine: data => {
            elements.message.textContent = `${data.message}..!`;
        }
    };

    window.addEventListener('message', e => {
        const handler = handlers[e.data.eventName];
        if (handler) {
            handler(e.data);
        }
    });
})();
