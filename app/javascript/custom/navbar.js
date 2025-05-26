document.addEventListener('turbo:load', function() {
  const navItems = document.querySelectorAll('.navbar ul li');

  function removeActiveClasses() {
    navItems.forEach(item => {
      item.classList.remove('active');
    });
  }

  navItems.forEach(item => {
    item.addEventListener('click', function(event) {
      removeActiveClasses();
      this.classList.add('active');
    });
  });
});
