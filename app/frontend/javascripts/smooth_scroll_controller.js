// app/javascript/controllers/smooth_scroll_controller.js
export default class SmoothScrollController {
    connect() {
        this.initSmoothScroll();
        this.initScrollAnimations();
    }

    initSmoothScroll() {
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', (e) => {
                e.preventDefault();
                const target = document.querySelector(anchor.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    }

    initScrollAnimations() {
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animate-fade-in');
                    // Не останавливаем наблюдение, чтобы анимация работала при повторном скролле
                } else {
                    // Убираем анимацию когда элемент скрыт (опционально)
                    // entry.target.classList.remove('animate-fade-in');
                }
            });
        }, observerOptions);

        // Наблюдаем за всеми элементами с классом animate-on-scroll
        document.querySelectorAll('.animate-on-scroll').forEach(element => {
            observer.observe(element);
        });
    }
}