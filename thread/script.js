// Variables de pagination
let currentPage = 1;
const messagesPerPage = 5;
let allMessages = [];

// Animation delay pour les messages
function setAnimationDelay() {
  const messages = document.querySelectorAll('.message');
  messages.forEach((msg, index) => {
    msg.style.animationDelay = `${index * 0.1}s`;
  });
}

// Formate la date pour un affichage plus convivial
function formatDate(dateString) {
  const date = new Date(dateString);
  const options = {
    day: 'numeric',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit',
  };
  return date.toLocaleDateString('fr-FR', options);
}

// Génére les contrôles de pagination
function renderPagination(totalMessages) {
  const paginationElement = document.getElementById('pagination');
  const pageInfoElement = document.getElementById('page-info');
  const totalPages = Math.ceil(totalMessages / messagesPerPage);

  if (totalPages <= 1) {
    paginationElement.innerHTML = '';
    pageInfoElement.innerHTML = '';
    return;
  }

  let paginationHTML = '';

  // Bouton précédent
  paginationHTML += `
    <button class="page-button ${currentPage === 1 ? 'disabled' : ''}" 
            ${currentPage === 1 ? 'disabled' : ''} 
            data-page="prev">
      &lt;
    </button>
  `;

  // Pages
  const maxVisibleButtons = 5;
  let startPage = Math.max(1, currentPage - Math.floor(maxVisibleButtons / 2));
  let endPage = Math.min(totalPages, startPage + maxVisibleButtons - 1);

  if (endPage - startPage + 1 < maxVisibleButtons) {
    startPage = Math.max(1, endPage - maxVisibleButtons + 1);
  }

  for (let i = startPage; i <= endPage; i++) {
    paginationHTML += `
      <button class="page-button ${i === currentPage ? 'active' : ''}" 
              data-page="${i}">
        ${i}
      </button>
    `;
  }

  // Bouton suivant
  paginationHTML += `
    <button class="page-button ${currentPage === totalPages ? 'disabled' : ''}" 
            ${currentPage === totalPages ? 'disabled' : ''} 
            data-page="next">
      &gt;
    </button>
  `;

  paginationElement.innerHTML = paginationHTML;
  pageInfoElement.innerHTML = `Page ${currentPage} sur ${totalPages} (${totalMessages} message${totalMessages > 1 ? 's' : ''})`;

  // écouteurs d'événements pour les boutons
  document.querySelectorAll('.page-button').forEach(button => {
    button.addEventListener('click', () => {
      if (button.classList.contains('disabled')) return;

      const page = button.getAttribute('data-page');
      if (page === 'prev') {
        currentPage--;
      } else if (page === 'next') {
        currentPage++;
      } else {
        currentPage = parseInt(page);
      }

      displayMessages();
    });
  });
}

// Affiche les messages de la page courante
function displayMessages() {
  const container = document.getElementById('messages');

  if (allMessages.length === 0) {
    container.innerHTML =
      '<div class="empty-messages">Aucun message pour le moment. Soyez le premier à écrire !</div>';
    return;
  }

  const start = (currentPage - 1) * messagesPerPage;
  const end = start + messagesPerPage;
  const paginatedMessages = allMessages.slice(start, end);

  container.innerHTML = '';
  paginatedMessages.forEach(msg => {
    container.innerHTML += `
      <div class="message">
        <div class="pseudo">${msg.pseudo}</div>
        <div class="content">${msg.content}</div>
        <div class="timestamp">${formatDate(msg.created_at)}</div>
      </div>
    `;
  });

  setAnimationDelay();
  renderPagination(allMessages.length);
}

// Fonction pour charger tous les messages
function loadMessages() {
  fetch('/api/messages')
    .then(res => res.json())
    .then(data => {
      allMessages = data;
      displayMessages();
    })
    .catch(err => {
      console.error('Erreur lors du chargement des messages:', err);
      document.getElementById('messages').innerHTML =
        `<div class="error">Erreur de chargement des messages: ${err.message}. Veuillez réessayer plus tard.</div>`;
    });
}

// Initialisation lors du chargement de la page
document.addEventListener('DOMContentLoaded', () => {
  // Charge messages immédiatement
  loadMessages();

  // Rafraîchi les messages toutes les 30 secondes
  // eslint-disable-next-line no-undef
  setInterval(loadMessages, 30000);
});
