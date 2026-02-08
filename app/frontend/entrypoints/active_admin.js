// import "@activeadmin/activeadmin";
// import "../styles/active_admin.css";
// import "../stylesheets/admin.css";
// import jquery from 'jquery';
// window.jQuery = window.$ = jquery; // Active Admin требует jQuery
// import '@activeadmin/activeadmin';


// app/frontend/entrypoints/login_controller.js
import "jquery-ui/ui/widget"

// Устанавливаем jQuery в глобальную область
window.jQuery = jquery;
window.$ = jquery;

// Импортируем CSS вместо SCSS
import './active_admin.css';

// Затем импортируем Active Admin
import '@activeadmin/activeadmin';

import "@hotwired/turbo-rails";
import "../javascripts/login_controller.js";