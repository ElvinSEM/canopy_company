// app/javascript/controllers/modal_controller.js
document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('leadModal');
    const modalBox = document.getElementById('leadModalBox');
    const closeBtn = document.getElementById('closeLeadModal');
    const form = document.getElementById('lead-form');

    // Функция открытия модалки
    window.openLeadModal = function() {
        if (!modal || !modalBox) return;

        // Сбрасываем форму при открытии
        if (form) {
            form.reset();
        }

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
        }, 300);
    };

    // Обработка отправки формы через AJAX
    if (form) {
        form.addEventListener('submit', async function(e) {
            e.preventDefault();

            const submitBtn = form.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;

            // Показываем индикатор загрузки
            submitBtn.disabled = true;
            submitBtn.innerHTML = 'Отправка...';

            try {
                const formData = new FormData(form);
                // Добавляем флаг, что форма из модалки
                formData.append('modal', 'true');

                const response = await fetch(form.action, {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                    }
                });

                const data = await response.json();

                if (data.success) {
                    // Показываем сообщение об успехе
                    form.innerHTML = `
                        <div class="text-center py-8">
                            <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                                </svg>
                            </div>
                            <h3 class="text-2xl font-bold text-gray-800 mb-2">Заявка отправлена!</h3>
                            <p class="text-gray-600">${data.message}</p>
                            <button onclick="closeLeadModal()" 
                                    class="mt-6 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                Закрыть
                            </button>
                        </div>
                    `;

                    // Автоматически закрываем через 3 секунды
                    setTimeout(() => {
                        closeLeadModal();
                        // Через еще секунду обновляем модалку
                        setTimeout(() => {
                            if (form) {
                                form.reset();
                                location.reload(); // или перезагружаем часть страницы
                            }
                        }, 1000);
                    }, 3000);
                } else {
                    // Показываем ошибки
                    let errorHtml = `
                        <div class="bg-red-50 border border-red-200 rounded-xl p-4 mb-4">
                            <div class="flex">
                                <div class="flex-shrink-0">
                                    <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                                    </svg>
                                </div>
                                <div class="ml-3">
                                    <h3 class="text-sm font-medium text-red-800">Ошибки:</h3>
                                    <div class="mt-2 text-sm text-red-700">
                                        <ul class="list-disc pl-5 space-y-1">
                    `;

                    data.errors.forEach(error => {
                        errorHtml += `<li>${error}</li>`;
                    });

                    errorHtml += `
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `;

                    // Вставляем ошибки перед формой
                    form.insertAdjacentHTML('afterbegin', errorHtml);

                    // Восстанавливаем кнопку
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalText;
                }
            } catch (error) {
                console.error('Error:', error);

                // Восстанавливаем кнопку
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;

                // Показываем общую ошибку
                alert('Произошла ошибка при отправке формы. Попробуйте еще раз.');
            }
        });
    }

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