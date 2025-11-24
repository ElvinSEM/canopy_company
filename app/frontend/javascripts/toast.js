// app/javascript/utils/toast.js
export class Toast {
    static show(message, type = 'success') {
        const container = document.getElementById('toast-container');
        if (!container) return;

        const toast = document.createElement('div');
        const styles = {
            success: 'bg-gradient-to-r from-green-500 to-emerald-600',
            error: 'bg-gradient-to-r from-red-500 to-pink-600',
            warning: 'bg-gradient-to-r from-orange-500 to-amber-600',
            info: 'bg-gradient-to-r from-blue-500 to-cyan-600'
        };

        const icons = {
            success: '✅',
            error: '❌',
            warning: '⚠️',
            info: '💡'
        };

        toast.className = `
      ${styles[type]} text-white px-6 py-4 rounded-xl shadow-2xl backdrop-blur-sm 
      transform transition-all duration-500 opacity-0 translate-y-2
      flex items-center space-x-3 font-medium
    `;

        toast.innerHTML = `
      <span class="text-lg flex-shrink-0">${icons[type]}</span>
      <span>${message}</span>
    `;

        container.appendChild(toast);

        // Анимация появления
        requestAnimationFrame(() => {
            toast.classList.remove('opacity-0', 'translate-y-2');
            toast.classList.add('opacity-100');
        });

        // Автоудаление
        setTimeout(() => {
            toast.classList.remove('opacity-100');
            toast.classList.add('opacity-0', 'translate-y-2');
            setTimeout(() => toast.remove(), 500);
        }, 4000);
    }
}

// Глобальные функции
window.showToast = Toast.show;
window.showSuccessToast = (message) => Toast.show(message, 'success');
window.showErrorToast = (message) => Toast.show(message, 'error');
window.showWarningToast = (message) => Toast.show(message, 'warning');
window.showInfoToast = (message) => Toast.show(message, 'info');