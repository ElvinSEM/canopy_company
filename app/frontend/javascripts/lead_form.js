document.addEventListener('DOMContentLoaded', () => {
    const leadForm = document.getElementById('lead-form');
    if (!leadForm) {
        console.warn("lead_form.js: форма не найдена");
        return;
    }

    console.log("lead_form.js: форма найдена, навешиваем обработчик");

    leadForm.addEventListener('submit', async (event) => {
        event.preventDefault();
        event.stopPropagation();

        if (!leadForm.checkValidity()) {
            leadForm.classList.add('was-validated');
            return;
        }

        const submitButton = leadForm.querySelector('button[type="submit"]');
        const originalText = submitButton.textContent;
        submitButton.disabled = true;
        submitButton.textContent = 'Отправка...';

        try {
            const formData = new FormData(leadForm);
            const response = await fetch(leadForm.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                }
            });

            const data = await response.json();

            if (response.ok) {
                console.log("Заявка успешно отправлена!", data);

                // Toast Bootstrap
                const toastEl = document.getElementById('success-toast');
                if (toastEl) {
                    const toast = new bootstrap.Toast(toastEl);
                    toast.show();
                }

                // Сброс формы
                leadForm.reset();
                leadForm.classList.remove('was-validated');

                // Закрытие модалки
                const modalEl = document.getElementById('leadModal');
                const modal = bootstrap.Modal.getInstance(modalEl);
                if (modal) modal.hide();
            } else {
                alert('Ошибка: ' + (data.error || 'Неизвестная ошибка'));
            }
        } catch (error) {
            console.error('Ошибка при отправке формы:', error);
            alert('Ошибка при отправке формы. Попробуйте ещё раз.');
        } finally {
            submitButton.disabled = false;
            submitButton.textContent = originalText;
        }
    });
});
