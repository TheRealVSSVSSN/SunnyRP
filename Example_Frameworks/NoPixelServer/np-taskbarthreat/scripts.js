$(function () {
  let lastTrigger = 0;

  const closeMain = () => {
    lastTrigger = 0;
    $('.divwrap').fadeOut(10);
  };

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.runProgress) {
      const percent = data.Length;

      if (percent >= 80 && lastTrigger !== 3) {
        lastTrigger = 3;
        $('.divwrap').fadeIn(10).fadeOut(5000);
      } else if (percent >= 60 && lastTrigger !== 2) {
        lastTrigger = 2;
        $('.divwrap').fadeIn(10).fadeOut(5000);
      } else if (percent > 30 && lastTrigger !== 1) {
        lastTrigger = 1;
        $('.divwrap').fadeIn(10).fadeOut(5000);
      }

      const red = Math.min(255, 100 + percent);
      const green = Math.max(0, 200 - percent * 2);

      $('.progress-bar').css({
        background: `rgba(${red},${green},0,0.6)`,
        width: `${percent}%`,
      });

      $('.nicesexytext').text(data.Task);
    }

    if (data.closeProgress) {
      closeMain();
    }
  });
});

