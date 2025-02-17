function validateRegisterForm() {
    const email = document.getElementById("register-email").value;
    const password = document.getElementById("register-password").value;
    const confirmPassword = document.getElementById("confirm-password").value;
    const cuit = document.getElementById("register-cuit").value;

    // Validar email (HTML5 ya valida, pero añadimos por redundancia)
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        alert("Por favor, ingrese un correo electrónico válido.");
        return false;
    }

    // Validar contraseña
    const passwordRegex = /^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
    if (!passwordRegex.test(password)) {
        alert("La contraseña debe tener al menos 8 caracteres, 1 mayúscula, 1 número y 1 símbolo.");
        return false;
    }

    // Validar que las contraseñas coincidan
    if (password !== confirmPassword) {
        alert("Las contraseñas no coinciden.");
        return false;
    }

    // Validar CUIT
    const cuitRegex = /^\d{2}-\d{8}-\d{1}$/;
    if (!cuitRegex.test(cuit)) {
        alert("El CUIT debe tener guiones (XX-XXXXXXXX-X).");
        return false;
    }

    // Si todo está correcto, se envía el formulario
    return true;
}