document.addEventListener("turbo:load", () => {
    const leadForm = document.querySelector("#lead-form");

    if (leadForm) {
        leadForm.addEventListener("submit", async (event) => {
            event.preventDefault();

            let formData = new FormData(leadForm);
            let submitButton = leadForm.querySelector("input[type=submit]");
            submitButton.disabled = true;

            try {
                let response = await fetch(leadForm.action, {
                    method: "POST",
                    body: formData,
                    headers: { "X-Requested-With": "XMLHttpRequest" },
                });

                let data = await response.json();
                if (response.ok) {
                    alert("Спасибо! Ваша заявка отправлена.");
                    leadForm.reset();
                    bootstrap.Modal.getInstance(document.querySelector("#leadModal")).hide();
                } else {
                    alert("Ошибка: " + data.error);
                }
            } catch (error) {
                console.error("Ошибка отправки:", error);
            } finally {
                submitButton.disabled = false;
            }
        });
    }
});
