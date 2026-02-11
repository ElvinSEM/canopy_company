import{A as f}from"./stimulus-uMCqvyjL.js";const m=f.start();m.debug=!1;window.Stimulus=m;document.addEventListener("DOMContentLoaded",function(){const e=document.getElementById("leadModal"),a=document.getElementById("leadModalBox"),n=document.getElementById("closeLeadModal"),t=document.getElementById("lead-form");window.openLeadModal=function(){!e||!a||(t&&t.reset(),e.classList.remove("hidden"),setTimeout(()=>{e.classList.add("flex"),e.classList.remove("opacity-0"),a.classList.remove("opacity-0","scale-95"),a.classList.add("opacity-100","scale-100")},10),document.body.style.overflow="hidden")},window.closeLeadModal=function(){!e||!a||(a.classList.remove("opacity-100","scale-100"),a.classList.add("opacity-0","scale-95"),e.classList.add("opacity-0"),setTimeout(()=>{e.classList.add("hidden"),e.classList.remove("flex","opacity-0"),document.body.style.overflow=""},300))},t&&t.addEventListener("submit",async function(s){s.preventDefault();const o=t.querySelector('button[type="submit"]'),r=o.innerHTML;o.disabled=!0,o.innerHTML="Отправка...";try{const d=new FormData(t);d.append("modal","true");const l=await(await fetch(t.action,{method:"POST",body:d,headers:{"X-Requested-With":"XMLHttpRequest","X-CSRF-Token":document.querySelector('meta[name="csrf-token"]').content}})).json();if(l.success)t.innerHTML=`
                        <div class="text-center py-8">
                            <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                                </svg>
                            </div>
                            <h3 class="text-2xl font-bold text-gray-800 mb-2">Заявка отправлена!</h3>
                            <p class="text-gray-600">${l.message}</p>
                            <button onclick="closeLeadModal()" 
                                    class="mt-6 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                Закрыть
                            </button>
                        </div>
                    `,setTimeout(()=>{closeLeadModal(),setTimeout(()=>{t&&(t.reset(),location.reload())},1e3)},3e3);else{let c=`
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
                    `;l.errors.forEach(u=>{c+=`<li>${u}</li>`}),c+=`
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `,t.insertAdjacentHTML("afterbegin",c),o.disabled=!1,o.innerHTML=r}}catch(d){console.error("Error:",d),o.disabled=!1,o.innerHTML=r,alert("Произошла ошибка при отправке формы. Попробуйте еще раз.")}}),n==null||n.addEventListener("click",closeLeadModal),e==null||e.addEventListener("click",function(s){s.target===e&&closeLeadModal()}),document.addEventListener("keydown",function(s){s.key==="Escape"&&!e.classList.contains("hidden")&&closeLeadModal()})});class i{static show(a,n="success"){const t=document.getElementById("toast-container");if(!t)return;const s=document.createElement("div"),o={success:"bg-gradient-to-r from-green-500 to-emerald-600",error:"bg-gradient-to-r from-red-500 to-pink-600",warning:"bg-gradient-to-r from-orange-500 to-amber-600",info:"bg-gradient-to-r from-blue-500 to-cyan-600"},r={success:"✅",error:"❌",warning:"⚠️",info:"💡"};s.className=`
      ${o[n]} text-white px-6 py-4 rounded-xl shadow-2xl backdrop-blur-sm 
      transform transition-all duration-500 opacity-0 translate-y-2
      flex items-center space-x-3 font-medium
    `,s.innerHTML=`
      <span class="text-lg flex-shrink-0">${r[n]}</span>
      <span>${a}</span>
    `,t.appendChild(s),requestAnimationFrame(()=>{s.classList.remove("opacity-0","translate-y-2"),s.classList.add("opacity-100")}),setTimeout(()=>{s.classList.remove("opacity-100"),s.classList.add("opacity-0","translate-y-2"),setTimeout(()=>s.remove(),500)},4e3)}}window.showToast=i.show;window.showSuccessToast=e=>i.show(e,"success");window.showErrorToast=e=>i.show(e,"error");window.showWarningToast=e=>i.show(e,"warning");window.showInfoToast=e=>i.show(e,"info");
