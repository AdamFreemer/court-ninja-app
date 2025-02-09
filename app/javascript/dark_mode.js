document.addEventListener('alpine:init', () => {
  Alpine.store('darkMode', {
    on: localStorage.getItem('darkMode') === 'true',

    toggle() {
      this.on = !this.on;
      localStorage.setItem('darkMode', this.on);
      this.updateDOM();
    },

    updateDOM() {
      if (this.on) {
        document.documentElement.classList.add('dark');
      } else {
        document.documentElement.classList.remove('dark');
      }
    }
  });
}); 