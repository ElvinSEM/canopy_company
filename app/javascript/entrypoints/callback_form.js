document.addEventListener("turbo:load", () => {
    const callbackForm = document.querySelector("#callback-form");

    if (!callbackForm) return; // Если формы нет, не выполняем код

    callbackForm.addEventListener("submit", async (event) => {
        event.preventDefault();

        let formData = new FormData(callbackForm);
        let submitButton = callbackForm.querySelector("input[type=submit]");
        submitButton.disabled = true;

        try {
            let response = await fetch(callbackForm.action, {
                method: "POST",
                body: formData,
                headers: { "X-Requested-With": "XMLHttpRequest" },
            });

            let data = await response.json();
            if (response.ok) {
                alert("Спасибо! Мы скоро свяжемся с вами.");
                callbackForm.reset();
                bootstrap.Modal.getInstance(document.querySelector("#callback-modal")).hide();
            } else {
                alert("Ошибка: " + data.error);
            }
        } catch (error) {
            console.error("Ошибка отправки:", error);
        } finally {
            submitButton.disabled = false;
        }
    });
});
