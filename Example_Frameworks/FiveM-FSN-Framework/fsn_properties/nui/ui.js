document.addEventListener('DOMContentLoaded', () => {
  const actionMenu = document.getElementById('actionmenu');
  const infoDiv = document.getElementById('property-info');
  const keysDiv = document.getElementById('property-keys');
  const weaponsDiv = document.getElementById('property-weapons');
  const moneyDiv = document.getElementById('property-money');
  const policeDiv = document.getElementById('property-police');

  const addButton = (parent, text, action, sub) => {
    const btn = document.createElement('button');
    btn.className = 'menuoption';
    if (action) btn.dataset.action = action;
    if (sub) btn.dataset.sub = sub;
    btn.innerHTML = text;
    parent.appendChild(btn);
    return btn;
  };

  const resetMenu = () => {
    actionMenu.style.display = 'block';
    document.querySelectorAll('#actionmenu > div').forEach(div => {
      div.style.display = div.dataset.parent ? 'none' : 'block';
    });
  };

  window.addEventListener('message', (event) => {
    const item = event.data;
    if (item.showmenu) {
      infoDiv.innerHTML = '';
      keysDiv.innerHTML = '';
      weaponsDiv.innerHTML = '';
      moneyDiv.innerHTML = '';
      policeDiv.innerHTML = '';
      resetMenu();
      if (item.forSale) {
        addButton(infoDiv, 'Purchase ($50,000)', 'info-buy');
      } else {
        if (item.isOwner) {
          addButton(infoDiv, 'Property Info', 'info-show');
          addButton(infoDiv, 'Pay Rent', 'info-rent');
          addButton(infoDiv, 'Edit Access', null, 'property-keys');
          addButton(keysDiv, '<b>ADD CHARID</b>', 'keys-grant');
          if (item.keys) {
            JSON.parse(item.keys).forEach(k => {
              if (k) addButton(keysDiv, `${k.name} (${k.id})`, `keys-remove-${k.id}`);
            });
          }
        }
        if (item.hasKeys) {
          addButton(infoDiv, 'Inventory', 'inventory');
          addButton(infoDiv, 'Weapons', null, 'property-weapons');
          addButton(weaponsDiv, '<b>DEPOSIT WEAPON</b>', 'weapon-deposit');
          if (item.weapons) {
            JSON.parse(item.weapons).forEach((w, i) => {
              if (w) addButton(weaponsDiv, `${w.name} (${w.owner.serial})`, `weapon-take-${i}`);
            });
          }
          addButton(infoDiv, 'Money', null, 'property-money');
          const balBtn = addButton(moneyDiv, `$${Number(item.money).toLocaleString()}`);
          balBtn.style.backgroundColor = 'rgba(255,255,255,0.0)';
          balBtn.style.color = 'green';
          balBtn.style.fontSize = '20px';
          balBtn.style.border = 'none';
          addButton(moneyDiv, 'Withdraw Cash', 'money-withdraw');
          addButton(moneyDiv, 'Deposit Cash', 'money-deposit');
        } else {
          addButton(infoDiv, 'Property Info', 'info-show');
          addButton(infoDiv, 'Rob Property', 'robbery');
        }
        if (item.DOJ || item.POLICE) {
          const polBtn = addButton(infoDiv, 'C/HC Options', null, 'property-police');
          polBtn.style.backgroundColor = '#b6d0f9';
          ['search', 'seize', 'empty', 'breach'].forEach(act => {
            const b = addButton(policeDiv, act.charAt(0).toUpperCase() + act.slice(1), `police-${act}-${item.property_id}`);
            b.style.backgroundColor = '#b6d0f9';
          });
        }
      }
    } else if (item.hidemenu) {
      actionMenu.style.display = 'none';
    }
  });

  actionMenu.addEventListener('click', (e) => {
    const target = e.target;
    if (!target.classList.contains('menuoption')) return;
    if (target.dataset.action) {
      sendData('ButtonClick', target.dataset.action);
    } else if (target.dataset.sub) {
      const menu = document.getElementById(target.dataset.sub);
      if (menu) {
        menu.style.display = 'block';
        target.parentElement.style.display = 'none';
      }
    }
  });
});

function sendData(name, data) {
  fetch(`https://fsn_properties/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data)
  }).catch(e => console.log(e));
}

