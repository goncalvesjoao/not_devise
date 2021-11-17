const Application = {
  replaceWith(selector, html) {
    const oldElement = document.querySelector(selector);
    const newElementContainer = document.createElement('div');

    newElementContainer.innerHTML = html;

    oldElement.replaceWith(newElementContainer.firstChild);
  },

  updateFlashMessages(html) {
    const flashContainer = document.getElementById("flash-container");

    flashContainer.innerHTML = html;
  }
}

export default Application
