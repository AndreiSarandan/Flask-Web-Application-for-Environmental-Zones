const btns = document.querySelectorAll(".btn");
const output = document.querySelectorAll(".notifications");
const closeBtn = document.querySelectorAll(".close-btn");


const message = document.createElement("div");
const success = document.createElement("div");
const danger = document.createElement("div");

notifications = [message, success, danger];

notifications.forEach(n => {
    n.classList.add("notification");

});

message.classList.add("info");
success.classList.add("success");
danger.classList.add("danger");


message.innerHTML = '< div ><span class="material-symbols-outilned icon">chat_bubble</span><p>---BLABLABLA---</p><span class="material-symbols-outlined close-btn"></span></div >';
success.innerHTML = '< div ><span class="material-symbols-outilned icon">chat_bubble</span><p>---SUCCESS COAE---</p><span class="material-symbols-outlined close-btn"></span></div >';
danger.innerHTML = '< div ><span class="material-symbols-outilned icon">chat_bubble</span><p>---DANGER COAE---</p><span class="material-symbols-outlined close-btn"></span></div >';


btns.forEach(btn => {
    btn.addEventListener("click", () => {
        const id = btn.dataset.alert;
        const n = notifications[id].cloneNode(true);
        output.appendChild(n);
    });
});

window.addEventListener("animationend", e => {
    if (e.target.classList.contains("notification")) {
        e.target.remove();
    }
});

window.addEventListener("click", e => {
    if (e.target.classList.contains("close-btn")) {
        e.target.parentElement.parentElement.remove();
    }
});