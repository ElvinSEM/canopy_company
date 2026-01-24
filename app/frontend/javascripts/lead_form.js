//
// document.addEventListener('DOMContentLoaded', function() {
//     const modal = document.getElementById('leadModal');
//     const modalBox = document.getElementById('leadModalBox');
//     const closeBtn = document.getElementById('closeLeadModal');
//     const form = document.getElementById('lead-form');
//
//     // Функция открытия модалки
//     window.openLeadModal = function() {
//         if (!modal || !modalBox) return;
//
//         // Сбрасываем форму при открытии
//         if (form) {
//             form.reset();
//         }
//
//         modal.classList.remove('hidden');
//         setTimeout(() => {
//             modal.classList.add('flex');
//             modal.classList.remove('opacity-0');
//             modalBox.classList.remove('opacity-0', 'scale-95');
//             modalBox.classList.add('opacity-100', 'scale-100');
//         }, 10);
//
//         document.body.style.overflow = 'hidden';
//     };
//
//     // Функция закрытия модалки
//     window.closeLeadModal = function() {
//         if (!modal || !modalBox) return;
//
//         modalBox.classList.remove('opacity-100', 'scale-100');
//         modalBox.classList.add('opacity-0', 'scale-95');
//         modal.classList.add('opacity-0');
//
//         setTimeout(() => {
//             modal.classList.add('hidden');
//             modal.classList.remove('flex', 'opacity-0');
//             document.body.style.overflow = '';
//         }, 300);
//     };
//
//     // Обработка отправки формы через AJAX
//     if (form) {
//         form.addEventListener('submit', async function(e) {
//             e.preventDefault();
//
//             const submitBtn = form.querySelector('button[type="submit"]');
//             const originalText = submitBtn.innerHTML;
//
//             // Показываем индикатор загрузки
//             submitBtn.disabled = true;
//             submitBtn.innerHTML = 'Отправка...';
//
//             try {
//                 const formData = new FormData(form);
//                 // Добавляем флаг, что форма из модалки
//                 formData.append('modal', 'true');
//
//                 const response = await fetch(form.action, {
//                     method: 'POST',
//                     body: formData,
//                     headers: {
//                         'X-Requested-With': 'XMLHttpRequest',
//                         'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
//                     }
//                 });
//
//                 const data = await response.json();
//
//                 if (data.success) {
//                     // Показываем сообщение об успехе
//                     form.innerHTML = `
//                         <div class="text-center py-8">
//                             <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
//                                 <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
//                                     <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
//                                 </svg>
//                             </div>
//                             <h3 class="text-2xl font-bold text-gray-800 mb-2">Заявка отправлена!</h3>
//                             <p class="text-gray-600">${data.message}</p>
//                             <button onclick="closeLeadModal()"
//                                     class="mt-6 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
//                                 Закрыть
//                             </button>
//                         </div>
//                     `;
//
//                     // Автоматически закрываем через 3 секунды
//                     setTimeout(() => {
//                         closeLeadModal();
//                         // Через еще секунду обновляем модалку
//                         setTimeout(() => {
//                             if (form) {
//                                 form.reset();
//                                 location.reload(); // или перезагружаем часть страницы
//                             }
//                         }, 1000);
//                     }, 3000);
//                 } else {
//                     // Показываем ошибки
//                     let errorHtml = `
//                         <div class="bg-red-50 border border-red-200 rounded-xl p-4 mb-4">
//                             <div class="flex">
//                                 <div class="flex-shrink-0">
//                                     <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
//                                         <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
//                                     </svg>
//                                 </div>
//                                 <div class="ml-3">
//                                     <h3 class="text-sm font-medium text-red-800">Ошибки:</h3>
//                                     <div class="mt-2 text-sm text-red-700">
//                                         <ul class="list-disc pl-5 space-y-1">
//                     `;
//
//                     data.errors.forEach(error => {
//                         errorHtml += `<li>${error}</li>`;
//                     });
//
//                     errorHtml += `
//                                         </ul>
//                                     </div>
//                                 </div>
//                             </div>
//                         </div>
//                     `;
//
//                     // Вставляем ошибки перед формой
//                     form.insertAdjacentHTML('afterbegin', errorHtml);
//
//                     // Восстанавливаем кнопку
//                     submitBtn.disabled = false;
//                     submitBtn.innerHTML = originalText;
//                 }
//             } catch (error) {
//                 console.error('Error:', error);
//
//                 // Восстанавливаем кнопку
//                 submitBtn.disabled = false;
//                 submitBtn.innerHTML = originalText;
//
//                 // Показываем общую ошибку
//                 alert('Произошла ошибка при отправке формы. Попробуйте еще раз.');
//             }
//         });
//     }
//
//     // Закрытие по крестику
//     closeBtn?.addEventListener('click', closeLeadModal);
//
//     // Закрытие по клику вне модалки
//     modal?.addEventListener('click', function(e) {
//         if (e.target === modal) closeLeadModal();
//     });
//
//     // Закрытие по Escape
//     document.addEventListener('keydown', function(e) {
//         if (e.key === 'Escape' && !modal.classList.contains('hidden')) {
//             closeLeadModal();
//         }
//     });
// });

// app/javascript/controllers/lead_form.js
// Если используете Stimulus, можно обернуть в контроллер
// Или просто подключить как отдельный модуль
// app/javascript/controllers/lead_form.js
export function initLeadForm() {
    const modal = document.getElementById('leadModal');
    const modalBox = document.getElementById('leadModalBox');
    const closeBtn = document.getElementById('closeLeadModal');
    const form = document.getElementById('lead-form');
    const formContainer = document.getElementById('form-container');

    // Функция открытия модалки
    window.openLeadModal = function() {
        if (!modal || !modalBox) return;

        // Сбрасываем форму при открытии
        if (form) {
            form.reset();
        }

        // Восстанавливаем первоначальную форму если она была заменена
        if (formContainer && !formContainer.innerHTML.includes('lead-form')) {
            restoreOriginalForm();
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

            // Восстанавливаем исходную форму через 300мс
            setTimeout(() => {
                restoreOriginalForm();
            }, 300);
        }, 300);
    };

    // Восстановление оригинальной формы
    function restoreOriginalForm() {
        // Используем AJAX для загрузки свежей формы
        fetch('/leads/new', {
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(response => response.text())
            .then(html => {
                // Извлекаем только форму из ответа
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const newForm = doc.querySelector('#lead-form')?.outerHTML;

                if (newForm && formContainer) {
                    formContainer.innerHTML = newForm;
                    // Переподключаем обработчики событий к новой форме
                    reconnectFormHandlers();
                }
            })
            .catch(error => {
                console.error('Error loading form:', error);
                // Если AJAX не сработал, перезагружаем страницу
                location.reload();
            });
    }

    // Переподключение обработчиков к новой форме
    function reconnectFormHandlers() {
        const newForm = document.getElementById('lead-form');
        if (newForm) {
            newForm.addEventListener('submit', handleFormSubmit);
        }
    }

    // Получение Telegram URL из data-атрибута
    function getTelegramUrl() {
        const formEl = document.getElementById('lead-form');
        if (formEl && formEl.dataset.telegramUrl) {
            return formEl.dataset.telegramUrl;
        }
        return 'https://t.me/naves_crimea'; // fallback
    }

    function getSuccessHTML(clientName = '') {
        const telegramUrl = getTelegramUrl();
        return `
    <div class="text-center py-4 sm:py-6">
      <div class="w-12 h-12 sm:w-14 sm:h-14 md:w-16 md:h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-3 sm:mb-4">
        <svg class="w-6 h-6 sm:w-7 sm:h-7 md:w-8 md:h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
        </svg>
      </div>
      
      <h3 class="text-lg sm:text-xl md:text-2xl font-bold text-gray-800 mb-2">✓ Готово!</h3>
      <p class="text-gray-600 text-sm mb-4">${clientName ? clientName + ', ' : ''}ваша заявка принята</p>
      
      <!-- КОМПАКТНЫЙ БЛОК TELEGRAM -->
      <div class="mb-4 sm:mb-6">
        <!-- Мини-заголовок -->
        <div class="flex items-center justify-center mb-2">
          <div class="w-8 h-8 sm:w-10 sm:h-10 bg-blue-100 rounded-lg flex items-center justify-center mr-2">
            <span class="text-blue-600 text-sm sm:text-base">📸</span>
          </div>
          <h4 class="text-sm sm:text-base font-semibold text-gray-800">Наши работы в Telegram</h4>
        </div>
        
        <!-- Компактная кнопка -->
        <a href="${telegramUrl}" 
           target="_blank"
           class="block w-full bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 
                  text-white font-medium py-2.5 px-4 rounded-lg transition-all duration-200 
                  shadow-sm hover:shadow-md active:scale-[0.98] text-sm sm:text-base">
          <div class="flex items-center justify-center">
            <span class="mr-2">Перейти в канал</span>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"/>
            </svg>
          </div>
        </a>
        
        <!-- Подпись -->
        <p class="text-xs text-gray-500 mt-2">Публичный канал с фото проектов</p>
      </div>
      
      <!-- Кнопки действий (такого же размера как в форме) -->
      <div class="flex flex-col xs:flex-row gap-2 sm:gap-3 justify-center">
        <button onclick="closeLeadModal()" 
                class="flex-1 px-4 py-2.5 bg-gray-100 hover:bg-gray-200 text-gray-800 
                       rounded-lg font-medium transition-colors text-sm border border-gray-300">
          Закрыть
        </button>
        <button onclick="restartForm()" 
                class="flex-1 px-4 py-2.5 bg-blue-600 hover:bg-blue-700 text-white 
                       rounded-lg font-medium transition-colors text-sm">
          Новая заявка
        </button>
      </div>
    </div>
  `;
    }
    // Генератор случайного числа "посетителей" для социального доказательства
    function getRandomVisitorsCount() {
        return Math.floor(Math.random() * 50) + 20; // от 20 до 70
    }

    // Функция перезапуска формы
    window.restartForm = function() {
        if (formContainer) {
            restoreOriginalForm();
        }
    };

    // HTML для ошибок
    function getErrorHTML(errors) {
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

        errors.forEach(error => {
            errorHtml += `<li>${error}</li>`;
        });

        errorHtml += `
            </ul>
          </div>
        </div>
      </div>
    `;
        return errorHtml;
    }

    // Обработчик отправки формы
    function handleFormSubmit(e) {
        e.preventDefault();
        const form = e.target;
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalText = submitBtn.innerHTML;

        // Показываем индикатор загрузки
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="inline-block animate-spin mr-2">⟳</span> Отправка...';

        const formData = new FormData(form);
        formData.append('modal', 'true');

        fetch(form.action, {
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Получаем имя клиента
                    const nameInput = form.querySelector('input[name="lead[name]"]');
                    const clientName = nameInput ? nameInput.value : '';

                    // Показываем сообщение об успехе с приглашением в Telegram
                    formContainer.innerHTML = getSuccessHTML(clientName);

                    // УБРАЛИ АВТОМАТИЧЕСКОЕ ЗАКРЫТИЕ!
                    // Форма остается открытой, пока пользователь сам не закроет её

                } else {
                    // Показываем ошибки
                    const errorHtml = getErrorHTML(data.errors || ['Неизвестная ошибка']);
                    form.insertAdjacentHTML('afterbegin', errorHtml);
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalText;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
                alert('Произошла ошибка при отправке формы. Попробуйте еще раз.');
            });
    }

    // Подключение обработчика к форме
    if (form) {
        form.addEventListener('submit', handleFormSubmit);
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
}

// Инициализация при загрузке документа
document.addEventListener('DOMContentLoaded', function() {
    if (document.getElementById('leadModal')) {
        initLeadForm();
    }
});