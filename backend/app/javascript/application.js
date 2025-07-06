// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Funcionalidad adicional para la aplicación
document.addEventListener('DOMContentLoaded', function() {
  // Auto-submit del formulario de búsqueda cuando se presiona Enter
  const searchInput = document.querySelector('input[name="search"]');
  if (searchInput) {
    searchInput.addEventListener('keypress', function(e) {
      if (e.key === 'Enter') {
        e.target.form.submit();
      }
    });
  }

  // Confirmación para eliminar eventos
  const deleteButtons = document.querySelectorAll('[data-confirm]');
  deleteButtons.forEach(button => {
    button.addEventListener('click', function(e) {
      if (!confirm(this.dataset.confirm)) {
        e.preventDefault();
      }
    });
  });

  // Animación de fade-in para las tarjetas
  const cards = document.querySelectorAll('.event-card');
  cards.forEach((card, index) => {
    card.style.animationDelay = `${index * 0.1}s`;
    card.classList.add('fade-in');
  });
}); 