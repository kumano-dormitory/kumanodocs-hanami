function showPassword() {
    const passInput = document.getElementById("login-password-input");
    if (passInput) {
        passInput.type = "text"
    }
}

function hidePassword() {
    const passInput = document.getElementById("login-password-input");
    if (passInput) {
        passInput.type = "password"
    }
}

function initialize() {
    const button = document.getElementById("password-show-checkbox");
    if (button) {
      button.addEventListener('change', function(e) {
        if (e.target.checked) {
          showPassword();
        } else {
          hidePassword();
        }
      });
    }
  }
  
  initialize();