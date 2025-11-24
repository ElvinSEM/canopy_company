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
            form?.reset();
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
});