import $ from 'jquery'

$(document).on('turbo:load', function() {
  const $navLinks = $('.navbar ul li a');

  function setActiveTabBasedOnURL() {
    const currentPath = window.location.pathname;

    $navLinks.closest('li').removeClass('active');

    $navLinks.each(function() {
      const $link = $(this);
      if ($link.attr('href') === currentPath) {
        $link.closest('li').addClass('active');
      }
    });
  }

  setActiveTabBasedOnURL();
});
