import{A as y}from"./stimulus-BElm3eHS.js";const h=y.start();h.debug=!1;window.Stimulus=h;function L(){const t=document.getElementById("leadModal"),r=document.getElementById("leadModalBox"),i=document.getElementById("closeLeadModal"),a=document.getElementById("lead-form"),s=document.getElementById("form-container");window.openLeadModal=function(){!t||!r||(a&&a.reset(),s&&!s.innerHTML.includes("lead-form")&&d(),t.classList.remove("hidden"),setTimeout(()=>{t.classList.add("flex"),t.classList.remove("opacity-0"),r.classList.remove("opacity-0","scale-95"),r.classList.add("opacity-100","scale-100")},10),document.body.style.overflow="hidden")},window.closeLeadModal=function(){!t||!r||(r.classList.remove("opacity-100","scale-100"),r.classList.add("opacity-0","scale-95"),t.classList.add("opacity-0"),setTimeout(()=>{t.classList.add("hidden"),t.classList.remove("flex","opacity-0"),document.body.style.overflow="",setTimeout(()=>{d()},300)},300))};function d(){fetch("/leads/new",{headers:{"X-Requested-With":"XMLHttpRequest"}}).then(e=>e.text()).then(e=>{var m;const c=(m=new DOMParser().parseFromString(e,"text/html").querySelector("#lead-form"))==null?void 0:m.outerHTML;c&&s&&(s.innerHTML=c,g())}).catch(e=>{console.error("Error loading form:",e),location.reload()})}function g(){const e=document.getElementById("lead-form");e&&e.addEventListener("submit",p)}function x(){const e=document.getElementById("lead-form");return e&&e.dataset.telegramUrl?e.dataset.telegramUrl:"https://t.me/naves_crimea"}function v(e=""){const o=x();return`
    <div class="text-center py-4 sm:py-6">
      <div class="w-12 h-12 sm:w-14 sm:h-14 md:w-16 md:h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-3 sm:mb-4">
        <svg class="w-6 h-6 sm:w-7 sm:h-7 md:w-8 md:h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
        </svg>
      </div>
      
      <h3 class="text-lg sm:text-xl md:text-2xl font-bold text-gray-800 mb-2">✓ Готово!</h3>
      <p class="text-gray-600 text-sm mb-4">${e?e+", ":""}ваша заявка принята</p>
      
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
        <a href="${o}" 
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
  `}window.restartForm=function(){s&&d()};function w(e){let o=`
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
    `;return e.forEach(n=>{o+=`<li>${n}</li>`}),o+=`
            </ul>
          </div>
        </div>
      </div>
    `,o}function p(e){e.preventDefault();const o=e.target,n=o.querySelector('button[type="submit"]'),c=n.innerHTML;n.disabled=!0,n.innerHTML='<span class="inline-block animate-spin mr-2">⟳</span> Отправка...';const m=new FormData(o);m.append("modal","true"),fetch(o.action,{method:"POST",body:m,headers:{"X-Requested-With":"XMLHttpRequest","X-CSRF-Token":document.querySelector('meta[name="csrf-token"]').content}}).then(l=>l.json()).then(l=>{if(l.success){const f=o.querySelector('input[name="lead[name]"]'),b=f?f.value:"";s.innerHTML=v(b)}else{const f=w(l.errors||["Неизвестная ошибка"]);o.insertAdjacentHTML("afterbegin",f),n.disabled=!1,n.innerHTML=c}}).catch(l=>{console.error("Error:",l),n.disabled=!1,n.innerHTML=c,alert("Произошла ошибка при отправке формы. Попробуйте еще раз.")})}a&&a.addEventListener("submit",p),i==null||i.addEventListener("click",closeLeadModal),t==null||t.addEventListener("click",function(e){e.target===t&&closeLeadModal()}),document.addEventListener("keydown",function(e){e.key==="Escape"&&!t.classList.contains("hidden")&&closeLeadModal()})}document.addEventListener("DOMContentLoaded",function(){document.getElementById("leadModal")&&L()});class u{static show(r,i="success"){const a=document.getElementById("toast-container");if(!a)return;const s=document.createElement("div"),d={success:"bg-gradient-to-r from-green-500 to-emerald-600",error:"bg-gradient-to-r from-red-500 to-pink-600",warning:"bg-gradient-to-r from-orange-500 to-amber-600",info:"bg-gradient-to-r from-blue-500 to-cyan-600"},g={success:"✅",error:"❌",warning:"⚠️",info:"💡"};s.className=`
      ${d[i]} text-white px-6 py-4 rounded-xl shadow-2xl backdrop-blur-sm 
      transform transition-all duration-500 opacity-0 translate-y-2
      flex items-center space-x-3 font-medium
    `,s.innerHTML=`
      <span class="text-lg flex-shrink-0">${g[i]}</span>
      <span>${r}</span>
    `,a.appendChild(s),requestAnimationFrame(()=>{s.classList.remove("opacity-0","translate-y-2"),s.classList.add("opacity-100")}),setTimeout(()=>{s.classList.remove("opacity-100"),s.classList.add("opacity-0","translate-y-2"),setTimeout(()=>s.remove(),500)},4e3)}}window.showToast=u.show;window.showSuccessToast=t=>u.show(t,"success");window.showErrorToast=t=>u.show(t,"error");window.showWarningToast=t=>u.show(t,"warning");window.showInfoToast=t=>u.show(t,"info");
