document.addEventListener('turbo:load', function() {
  const navItems = document.querySelectorAll('.navbar ul li');
  const navLinks = document.querySelectorAll('.navbar ul li a');

  function removeActiveClasses() {
    navItems.forEach(item => {
      item.classList.remove('active');
    });
  }

  function setActiveTabBasedOnURL() {
    const currentPath = window.location.pathname;
    let foundActive = false;

    removeActiveClasses();

    navLinks.forEach(link => {
      const linkPath = link.getAttribute('href');

      if (linkPath === currentPath) {
        link.closest('li').classList.add('active');
      }
    });
  }

  setActiveTabBasedOnURL();
});
