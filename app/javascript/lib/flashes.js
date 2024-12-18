export async function flash(content, displayTime) {
    if (typeof displayTime === 'undefined') {
        displayTime = Math.max(content.length * 80, 3500);
    }

    let oldFlashDiv = document.querySelector('.dynamic-flash');
    if (oldFlashDiv) {
        document.body.removeChild(oldFlashDiv);
    }

    const parentElement = document.querySelector('.dynamic-flash-container');

    let flashDiv = document.createElement('DIV');
    flashDiv.innerText = content;
    flashDiv.classList.add('dynamic-flash');
    await parentElement.appendChild(flashDiv);

    setTimeout(() => {
        flashDiv.classList.add('animate-in');
    }, 10);

    setTimeout(() => {
        parentElement.removeChild(flashDiv);
    }, displayTime);
}