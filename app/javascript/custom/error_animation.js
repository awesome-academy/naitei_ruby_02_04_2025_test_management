document.addEventListener('turbo:render', function() {
  const errorExplanation = document.getElementById('error_explanation');

  if (errorExplanation) {
    const displayDuration = 3000;
    const fadeOutAnimationDuration = 500;

    setTimeout(() => {
      if (errorExplanation) {
        errorExplanation.classList.add('hiding');

        setTimeout(() => {
          if (errorExplanation) {
            errorExplanation.style.display = 'none';
          }
        }, fadeOutAnimationDuration);
      }
    }, displayDuration);
  }
});
