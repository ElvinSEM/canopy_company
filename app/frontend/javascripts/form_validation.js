// document.addEventListener("turbo:load", function () {
//     const form = document.getElementById("lead-form");
//
//     if (!form || !(form instanceof HTMLFormElement)) {
//         console.warn("❗ Элемент #lead-form не найден. Возможно, он отсутствует на этой странице.");
//         return;
//     }
//
//     const submitButton = form.querySelector("button[type='submit']");
//
//     form.addEventListener("submit", function (event) {
//         event.preventDefault(); // Останавливаем стандартную отправку формы
//
//         // Проверяем валидность формы
//         if (!form.checkValidity()) {
//             form.classList.add("was-validated"); // Добавляем Bootstrap-валидацию
//             return;
//         }
//
//         // Подтверждение отправки
//         if (!confirm("Вы уверены, что хотите отправить заявку?")) return;
//
//         const formData = new FormData(form);
//         submitButton.disabled = true; // Блокируем кнопку во время отправки
//
//         fetch(form.action, {
//             method: "POST",
//             body: formData,
//             headers: {
//                 "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
//                 "Accept": "application/json"
//             }
//         })
//             .then(response => response.json())
//             .then(data => {
//                 if (data.error) {
//                     alert("Ошибка: " + data.error);
//                 } else {
//                     alert("Заявка успешно отправлена!");
//                     form.reset();
//                     form.classList.remove("was-validated");
//                 }
//             })
//             .catch(error => {
//                 console.error("Ошибка:", error);
//                 alert("Произошла ошибка при отправке заявки. Попробуйте ещё раз.");
//             })
//             .finally(() => {
//                 submitButton.disabled = false;
//             });
//     });
// });



// app/frontend/entrypoints/form_validation.js

document.addEventListener("turbo:load", () => {
    const forms = document.querySelectorAll(".needs-validation");

    forms.forEach((form) => {
        form.addEventListener("submit", (event) => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add("was-validated");
        }, false);
    });
});

