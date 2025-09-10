document.addEventListener('DOMContentLoaded', () => {
  const cursor = document.getElementById('cursor');
  const contractContainer = document.querySelector('.contract-container');
  const contractContainer2 = document.querySelector('.contract-container2');
  const contractContainer3 = document.querySelector('.contract-container3');
  const home = document.querySelector('.home');
  const fullScreen = document.querySelector('.full-screen');

  const post = (path, data = {}) => fetch(`https://np-contracts/${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data)
  });

  const show = el => el.style.display = 'block';
  const hide = el => el.style.display = 'none';

  document.querySelector('.btnPrev').addEventListener('click', e => {
    e.preventDefault();
    post('previousID');
  });

  document.querySelector('.btnNext').addEventListener('click', e => {
    e.preventDefault();
    post('nextID');
  });

  document.querySelector('.btnPay').addEventListener('click', e => {
    e.preventDefault();
    post('payID');
  });

  document.querySelector('.btnGive').addEventListener('click', e => {
    e.preventDefault();
    post('giveID', {
      target: document.getElementById('contractID2').value,
      conamount: document.getElementById('contractAmount2').value,
      coninformation: document.getElementById('contractInfo2').value
    });
  });

  window.addEventListener('message', ({ data }) => {
    switch (data.openSection) {
      case 'contractUpdate':
        show(home);
        show(contractContainer);
        show(fullScreen);
        cursor.style.display = 'block';
        document.querySelector('.contractID').innerHTML = data.NUIcontractID;
        document.querySelector('.contractAmount').innerHTML = data.NUIcontractAmount;
        document.querySelector('.contractInfo').innerHTML = data.NUIcontractInfo;
        break;
      case 'openContractDummy':
        show(home);
        show(contractContainer3);
        cursor.style.display = 'block';
        document.querySelector('.contractID3').textContent = 'Sign Here';
        document.querySelector('.contractAmount3').textContent = data.price;
        document.querySelector('.contractInfo3').textContent = data.strg;
        break;
      case 'openContracts':
        show(home);
        show(contractContainer);
        cursor.style.display = 'block';
        break;
      case 'openContractStart':
        show(home);
        show(contractContainer2);
        cursor.style.display = 'block';
        break;
      case 'close':
        hide(home);
        hide(contractContainer);
        hide(contractContainer2);
        hide(contractContainer3);
        cursor.style.display = 'none';
        break;
    }
  });

  document.addEventListener('mousemove', e => {
    cursor.style.left = `${e.pageX}px`;
    cursor.style.top = `${e.pageY}px`;
  });

  document.addEventListener('keyup', e => {
    if (e.key === 'Escape') {
      post('close');
    } else if (e.key === 'ArrowLeft') {
      post('previousID');
    } else if (e.key === 'ArrowRight') {
      post('nextID');
    }
  });
});

