// app/javascript/controllers/modal_controller.js
document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('leadModal');
    const modalBox = document.getElementById('leadModalBox');
    const closeBtn = document.getElementById('closeLeadModal');
    const form = document.getElementById('lead-form');

    // Функция открытия модалки
    window.openLeadModal = function() {
        if (!modal || !modalBox) return;

        modal.classList.remove('hidden');
        setTimeout(() => {
            modal.classList.add('flex');
            modal.classList.remove('opacity-0');
            modalBox.classList.remove('opacity-0', 'scale-95');
            modalBox.classList.add('opacity-100', 'scale-100');
        }, 10);

        document.body.style.overflow = 'hidden';
    };

    // Функция закрытия модалки
    window.closeLeadModal = function() {
        if (!modal || !modalBox) return;

        modalBox.classList.remove('opacity-100', 'scale-100');
        modalBox.classList.add('opacity-0', 'scale-95');
        modal.classList.add('opacity-0');

        setTimeout(() => {
            modal.classList.add('hidden');
            modal.classList.remove('flex', 'opacity-0');
            document.body.style.overflow = '';
            form.reset();
        }, 300);
    };

    // Закрытие по крестику
    closeBtn?.addEventListener('click', closeLeadModal);

    // Закрытие по клику вне модалки
    modal?.addEventListener('click', function(e) {
        if (e.target === modal) closeLeadModal();
    });

    // Закрытие по Escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && !modal.classList.contains('hidden')) {
            closeLeadModal();
        }
    });

    // Обработка отправки формы
    form?.addEventListener('submit', async function(e) {
        e.preventDefault();

        const submitBtn = document.getElementById('submit-btn');
        const originalText = submitBtn.innerHTML;

        // Показываем загрузку
        submitBtn.disabled = true;
        submitBtn.innerHTML = `
      <span class="flex items-center justify-center space-x-2">
        <svg class="w-5 h-5 animate-spin" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
        </svg>
        <span>Отправка...</span>
      </span>
    `;

        try {
            const formData = new FormData(form);
            const response = await fetch(form.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'Accept': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });

            if (response.ok) {
                closeLeadModal();
                if (typeof showToast === 'function') {
                    showToast('Заявка успешно отправлена! Мы свяжемся с вами в течение 15 минут', 'success');
                }
            } else {
                throw new Error('Ошибка сервера');
            }
        } catch (error) {
            if (typeof showToast === 'function') {
                showToast('Ошибка при отправке. Пожалуйста, попробуйте еще раз.', 'error');
            }
        } finally {
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
        }
    });
});