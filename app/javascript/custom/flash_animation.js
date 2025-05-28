document.addEventListener('turbo:render', function() {
  const flashMes = document.querySelector('.flash-mes');

  if (flashMes) {
    const displayDuration = 3000;
    const fadeOutAnimationDuration = 500;

    setTimeout(() => {
      if (flashMes) {
        flashMes.classList.add('hiding');

        setTimeout(() => {
          if (flashMes) {
            flashMes.style.display = 'none';
          }
        }, fadeOutAnimationDuration);
      }
    }, displayDuration);
  }
});
