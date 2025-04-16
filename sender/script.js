// Gestion de l'envoi de messages
const form = document.getElementById('messageForm');
const status = document.getElementById('status');

form.addEventListener('submit', async e => {
  e.preventDefault();

  const data = {
    pseudo: form.pseudo.value,
    content: form.content.value,
  };

  try {
    const res = await fetch('/api/messages', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });

    if (res.ok) {
      status.textContent = '✅ Message envoyé avec succès !';
      status.className = 'success';
      form.reset();
    } else {
      const err = await res.json();
      status.textContent = err.error || '❌ Une erreur est survenue.';
      status.className = 'error';
    }
  } catch (error) {
    console.error('Erreur de connexion:', error);
    status.textContent = `😵 Erreur réseau: ${error.message}`;
    status.className = 'error';
  }
});
