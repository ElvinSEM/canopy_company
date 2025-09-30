// import * as bootstrap from "bootstrap";
//
// document.addEventListener("DOMContentLoaded", () => {
//     // Инициализация всех модальных окон по атрибуту data-bs-toggle="modal"
//     const modals = document.querySelectorAll(".modal");
//
//     modals.forEach(modalEl => {
//         const modalInstance = new bootstrap.Modal(modalEl);
//
//         // Открытие модалки при клике на кнопки с соответствующим data-bs-target
//         document.querySelectorAll(`[data-bs-target='#${modalEl.id}']`).forEach(button => {
//             button.addEventListener("click", () => {
//                 modalInstance.show();
//             });
//         });
//
//         // Можно добавить общую обработку закрытия
//         modalEl.addEventListener("hidden.bs.modal", () => {
//             console.log(`Модалка #${modalEl.id} закрыта`);
//         });
//     });
// });
//
// // Автоочистка формы + Toast после успешной отправки
// document.addEventListener("turbo:submit-end", event => {
//     const form = event.target;
//     const modal = form.closest(".modal");
//
//     if (event.detail.success) {
//         // Сброс формы
//         form.reset();
//
//         // Закрытие модального окна
//         if (modal) {
//             const modalInstance = bootstrap.Modal.getInstance(modal);
//             modalInstance.hide();
//         }
//
//         // Показ Toast-уведомления
//         const toastEl = document.getElementById("success-toast");
//         if (toastEl) {
//             const toast = bootstrap.Toast.getOrCreateInstance(toastEl);
//             toast.show();
//         }
//     }
// });



// app/javascript/entrypoints/modal.js
import * as bootstrap from "bootstrap";

document.addEventListener("turbo:load", () => {
    const leadForm = document.getElementById("lead-form");

    if (leadForm) {
        leadForm.addEventListener("ajax:success", () => {
            // Закрыть модалку после отправки
            const modalElement = document.getElementById("leadModal");
            if (modalElement) {
                const modalInstance = bootstrap.Modal.getInstance(modalElement) || new bootstrap.Modal(modalElement);
                modalInstance.hide();
            }

            // Показать тост "Заявка успешно отправлена!"
            const toastElement = document.getElementById("success-toast");
            if (toastElement) {
                const toast = new bootstrap.Toast(toastElement);
                toast.show();
            }
        });

        leadForm.addEventListener("ajax:error", (event) => {
            console.error("Ошибка при отправке формы", event.detail);
        });
    }
});
