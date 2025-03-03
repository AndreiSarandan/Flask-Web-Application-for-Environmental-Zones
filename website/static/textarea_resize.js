// NOT WORKING !!!!!!!!!!!!!!!!!!!!! textarea_resize.js

// Auto-resize text areas based on content
function autoResizeTextArea(textArea) {
    textArea.style.height = "auto";
    textArea.style.height = (textArea.scrollHeight) + "px";
}

// Auto-resize text areas initially and on input
document.addEventListener("DOMContentLoaded", function () {
    const originTextArea = document.getElementById("origin-description-output");
    const destinationTextArea = document.getElementById("description-description-output");

    autoResizeTextArea(originTextArea);
    autoResizeTextArea(destinationTextArea);

    originTextArea.addEventListener("input", function () {
        autoResizeTextArea(originTextArea);
    });

    destinationTextArea.addEventListener("input", function () {
        autoResizeTextArea(destinationTextArea);
    });
});