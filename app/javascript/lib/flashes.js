function cleanupOldFlashes() {
    const oldFlashes = document.querySelectorAll('.dynamic-flash');
    oldFlashes.forEach((oldFlash) =>
        oldFlash.parentElement.removeChild(oldFlash)
    )
}

function setAnimationTimes(contentLength, flashDiv, parentElement, displayTime) {
    if (displayTime === undefined) {
        displayTime = Math.max(contentLength * 80, 3500);
    }

    setTimeout(() => {
        flashDiv.classList.add('animate-in');
    }, 10);

    setTimeout(() => {
        parentElement.removeChild(flashDiv);
    }, displayTime);
}

export async function flash(content, displayTime) {
    cleanupOldFlashes();

    const parentElement = document.querySelector('.dynamic-flash-container');
    let flashDiv = document.createElement('DIV');
    flashDiv.innerText = content;
    flashDiv.classList.add('dynamic-flash');
    flashDiv.classList.add('big-flash');
    await parentElement.appendChild(flashDiv);

    setAnimationTimes(content.length, flashDiv, parentElement, displayTime);
}

export async function miniFlash(content, displayTime, parentElement) {
    cleanupOldFlashes();

    let flashDiv = document.createElement('DIV');
    flashDiv.innerText = content;
    flashDiv.classList.add("dynamic-flash");
    flashDiv.classList.add("mini-flash");
    await parentElement.appendChild(flashDiv);

    setAnimationTimes(content.length, flashDiv, parentElement, displayTime);
}
