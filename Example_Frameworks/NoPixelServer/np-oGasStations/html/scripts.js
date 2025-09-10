document.addEventListener('DOMContentLoaded', () => {
  window.addEventListener('message', (event) => {
    const item = event.data;

    if (item.open === 2) {
      if (item.direction) {
        const dirImage = document.querySelector('.direction .image');
        if (dirImage) dirImage.style.transform = `translate3d(${item.direction}px, 0px, 0px)`;
        return;
      }

      const atlAmount = document.querySelector('.atlamount');
      const atlText = document.querySelector('.atlamounttxt');
      if (item.atl === false) {
        atlAmount.style.display = 'none';
        atlText.style.display = 'none';
      } else {
        atlAmount.style.display = 'block';
        atlText.style.display = 'block';
        atlAmount.textContent = item.atl;
      }

      document.querySelector('.vehicle').classList.remove('hide');
      document.querySelector('.wrap').classList.remove('lower');
      document.querySelector('.time').classList.remove('timelower');

      document.querySelector('.fuelamount').textContent = item.fuel;
      document.querySelector('.speedamount').textContent = item.mph;
      document.querySelector('.street-txt').textContent = item.street;
      document.querySelector('.time').textContent = item.time;

      const beltEl = document.querySelector('.belt');
      if (item.belt || item.harnessDur > 0) {
        beltEl.style.display = 'none';
      } else {
        beltEl.style.display = 'block';
      }

      document.querySelector('.ENGINE').style.display = item.engine ? 'block' : 'none';
      document.querySelector('.FUEL').style.display = item.GasTank ? 'block' : 'none';

      const harnessEl = document.querySelector('.harness');
      harnessEl.innerHTML = '';
      if (item.harnessDur > 0) {
        if (item.harness) {
          const colorOn = item.colorblind ? 'blue' : 'green';
          harnessEl.innerHTML = `<div class="${colorOn}"> HARNESS </div>`;
        } else {
          const colorOff = item.colorblind ? 'yellow' : 'red';
          harnessEl.innerHTML = `<div class="${colorOff}"> HARNESS </div>`;
        }
      }

      const nosEl = document.querySelector('.nos');
      nosEl.innerHTML = '';
      if (item.nos > 0) {
        if (!item.nosEnabled) {
          const colorOn = item.colorblind ? 'blue' : 'green';
          nosEl.innerHTML = `<div class="${colorOn}"> ${item.nos} </div>`;
        } else {
          const colorOff = item.colorblind ? 'yellow' : 'yellow';
          nosEl.innerHTML = `<div class="${colorOff}"> ${item.nos} </div>`;
        }
      }
    }

    if (item.open === 4) {
      document.querySelector('.vehicle').classList.add('hide');
      document.querySelector('.wrap').classList.add('lower');
      document.querySelector('.time').classList.add('timelower');
      document.querySelector('.fuelamount').textContent = '';
      document.querySelector('.speedamount').textContent = '';
      document.querySelector('.street-txt').textContent = '';
      document.querySelector('.time').textContent = item.time;
      const dirImage = document.querySelector('.direction .image');
      if (dirImage) dirImage.style.transform = `translate3d(${item.direction}px, 0px, 0px)`;
    }

    if (item.open === 3) {
      document.querySelector('.full-screen').style.display = 'none';
    }

    if (item.open === 1) {
      document.querySelector('.full-screen').style.display = 'block';
    }
  });
});
