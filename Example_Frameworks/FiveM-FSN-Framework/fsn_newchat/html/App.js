(() => {
  const state = {
    templates: CONFIG.templates,
    suggestions: [],
    oldMessages: [],
    oldIndex: -1,
    fadeTimer: null,
    showInput: false
  };

  const chatWindow = document.getElementById('chat-window');
  const msgContainer = document.getElementById('chat-messages');
  const inputContainer = document.getElementById('chat-input');
  const input = document.getElementById('input');
  const suggestionsEl = document.getElementById('suggestions');

  function post(url, data) {
    const request = new XMLHttpRequest();
    request.open('POST', url, true);
    request.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
    request.send(data);
  }

  function escapeHTML(str) {
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  function colorizeOld(str, color) {
    return `<span style="color: rgb(${color[0]}, ${color[1]}, ${color[2]})">${str}</span>`;
  }

  function colorize(str) {
    let s = '<span>' + str.replace(/\^([0-9])/g, (m, c) => `</span><span class="color-${c}">`) + '</span>';
    const styleDict = {
      '*': 'font-weight: bold;',
      '_': 'text-decoration: underline;',
      '~': 'text-decoration: line-through;',
      '=': 'text-decoration: underline line-through;',
      'r': 'text-decoration: none;font-weight: normal;'
    };
    const styleRegex = /\^(\_|\*|\=|\~|\/|r)(.*?)(?=$|\^r|<\/em>)/;
    while (s.match(styleRegex)) {
      s = s.replace(styleRegex, (str, style, inner) => `<em style="${styleDict[style]}">${inner}</em>`);
    }
    return s.replace(/<span[^>]*><\/span[^>]*>/g, '');
  }

  function formatMessage(message) {
    let template = message.template || state.templates[message.templateId];
    if (!template) {
      template = state.templates[CONFIG.defaultTemplateId];
    }

    if (message.templateId === CONFIG.defaultTemplateId && message.args && message.args.length === 1) {
      template = state.templates[CONFIG.defaultAltTemplateId];
    }

    template = template.replace(/{(\d+)}/g, (match, number) => {
      const argEscaped = message.args[number] !== undefined ? escapeHTML(message.args[number]) : match;
      if (number == 0 && message.color) {
        return colorizeOld(argEscaped, message.color);
      }
      return argEscaped;
    });

    return colorize(template);
  }

  function pushMessage(message) {
    const div = document.createElement('div');
    div.className = 'msg' + (message.multiline ? ' multiline' : '');
    div.innerHTML = formatMessage(message);
    msgContainer.appendChild(div);
    msgContainer.scrollTop = msgContainer.scrollHeight;
    showWindow();
  }

  function showWindow() {
    chatWindow.style.display = 'block';
    resetFadeTimer();
  }

  function resetFadeTimer() {
    if (state.fadeTimer) {
      clearTimeout(state.fadeTimer);
    }
    state.fadeTimer = setTimeout(() => {
      if (!state.showInput) {
        chatWindow.style.display = 'none';
      }
    }, CONFIG.fadeTimeout);
  }

  function openInput() {
    state.showInput = true;
    chatWindow.style.display = 'block';
    inputContainer.style.display = 'block';
    input.focus();
    resetFadeTimer();
  }

  function hideInput(canceled) {
    state.showInput = false;
    inputContainer.style.display = 'none';
    if (canceled) {
      post('http://fsn_newchat/chatResult', JSON.stringify({ canceled: true }));
    } else if (input.value !== '') {
      post('http://fsn_newchat/chatResult', JSON.stringify({ message: input.value }));
      state.oldMessages.unshift(input.value);
      state.oldIndex = -1;
    }
    input.value = '';
    suggestionsEl.innerHTML = '';
    resetFadeTimer();
  }

  function addSuggestion(suggestion) {
    if (!suggestion.params) suggestion.params = [];
    if (state.suggestions.find(s => s.name === suggestion.name)) return;
    state.suggestions.push(suggestion);
  }

  function removeSuggestion(name) {
    state.suggestions = state.suggestions.filter(s => s.name !== name);
    updateSuggestions();
  }

  function clearChat() {
    msgContainer.innerHTML = '';
    state.oldMessages = [];
    state.oldIndex = -1;
  }

  function updateSuggestions() {
    const message = input.value;
    suggestionsEl.innerHTML = '';
    if (message === '') return;

    const current = state.suggestions.filter((s) => {
      if (!s.name.startsWith(message)) {
        const sugSplit = s.name.split(' ');
        const msgSplit = message.split(' ');
        for (let i = 0; i < msgSplit.length; i += 1) {
          if (i >= sugSplit.length) {
            return i < sugSplit.length + s.params.length;
          }
          if (sugSplit[i] !== msgSplit[i]) {
            return false;
          }
        }
      }
      return true;
    }).slice(0, CONFIG.suggestionLimit);

    current.forEach((s) => {
      const li = document.createElement('li');
      li.className = 'suggestion';
      const p = document.createElement('p');
      const nameSpan = document.createElement('span');
      nameSpan.textContent = s.name;
      if (!s.name.startsWith(message)) nameSpan.classList.add('disabled');
      p.appendChild(nameSpan);
      s.params.forEach((param, index) => {
        const paramSpan = document.createElement('span');
        paramSpan.className = 'param';
        paramSpan.textContent = `[${param.name}]`;
        const wType = (index === s.params.length - 1) ? '.' : '\\S';
        const regex = new RegExp(`${s.name} (?:\\w+ ){${index}}(?:${wType}*)$`, 'g');
        if (message.match(regex) == null) paramSpan.classList.add('disabled');
        p.appendChild(paramSpan);
      });
      li.appendChild(p);
      const help = document.createElement('small');
      help.className = 'help';
      if (!s.disabled) help.textContent = s.help;
      s.params.forEach((param) => {
        if (!param.disabled) help.textContent += param.help;
      });
      li.appendChild(help);
      suggestionsEl.appendChild(li);
    });
  }

  input.addEventListener('input', updateSuggestions);

  input.addEventListener('keydown', (e) => {
    if (e.keyCode === 38 || e.keyCode === 40) {
      e.preventDefault();
      moveOldMessageIndex(e.keyCode === 38);
    } else if (e.keyCode === 33) {
      msgContainer.scrollTop -= 100;
    } else if (e.keyCode === 34) {
      msgContainer.scrollTop += 100;
    }
  });

  input.addEventListener('keyup', (e) => {
    input.style.height = '5px';
    input.style.height = `${input.scrollHeight + 2}px`;
    if (e.key === 'Escape') {
      hideInput(true);
    }
  });

  input.addEventListener('keypress', (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      hideInput(false);
    }
  });

  function moveOldMessageIndex(up) {
    if (up && state.oldMessages.length > state.oldIndex + 1) {
      state.oldIndex += 1;
      input.value = state.oldMessages[state.oldIndex];
    } else if (!up && state.oldIndex - 1 >= 0) {
      state.oldIndex -= 1;
      input.value = state.oldMessages[state.oldIndex];
    } else if (!up && state.oldIndex - 1 === -1) {
      state.oldIndex = -1;
      input.value = '';
    }
    updateSuggestions();
  }

  window.addEventListener('message', (event) => {
    const data = event.data || event.detail;
    switch (data.type) {
      case 'ON_OPEN':
        openInput();
        break;
      case 'ON_MESSAGE':
        pushMessage(data.message);
        break;
      case 'ON_SUGGESTION_ADD':
        addSuggestion(data.suggestion);
        break;
      case 'ON_SUGGESTION_REMOVE':
        removeSuggestion(data.name);
        break;
      case 'ON_TEMPLATE_ADD':
        state.templates[data.template.id] = data.template.html;
        break;
      case 'ON_CLEAR':
        clearChat();
        break;
      default:
        break;
    }
  });

  window.post = post;
  post('http://fsn_newchat/loaded', JSON.stringify({}));
})();
