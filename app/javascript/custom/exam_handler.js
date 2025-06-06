$(document).on('turbo:load', function() {
  const $examForm = $('#exam-form');

  if ($examForm.length === 0) {
    return;
  }

  const $timerElement = $('#exam-timer');
  if ($timerElement.length > 0) {
    const endTimeString = $timerElement.data('end-time');

    if (endTimeString) {
      const endTime = new Date(endTimeString).getTime();

      const timerInterval = setInterval(function() {
        const now = new Date().getTime();
        const distance = endTime - now;

        if (distance < 0) {
          clearInterval(timerInterval);
          $timerElement.html("Hết giờ!");

          if (!$examForm.data('submitted')) {
            $examForm.trigger('submit');
          }
          return;
        }

        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((distance % (1000 * 60)) / 1000);

        const displayTime = `Thời gian còn lại: ${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        $timerElement.html(displayTime);
      }, 1000);
    } else {
      $timerElement.html("Không giới hạn thời gian");
    }
  }

  $examForm.data('submitted', false);

  const $window = $(window);

  const handlePageHide = function() {
    if (!$examForm.data('submitted')) {
      navigator.sendBeacon($examForm.attr('action'), new FormData($examForm[0]));
    }
  };

  const handleBeforeUnloadWarning = function(event) {
    if (!$examForm.data('submitted')) {
      return 'Các thay đổi bạn đã thực hiện có thể không được lưu.';
    }
  };

  $window.on('beforeunload', handleBeforeUnloadWarning);
  $window.on('pagehide', handlePageHide);

  $examForm.on('submit', function() {
    $examForm.data('submitted', true);
    $window.off('beforeunload', handleBeforeUnloadWarning);
    $window.off('pagehide', handlePageHide);
  });
});
