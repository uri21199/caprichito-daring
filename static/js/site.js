async function loadSiteInfo() {
    try {
        const response = await fetch("/api/site-info"); // Llamada a la API
        const data = await response.json();

        // Contact Information
        document.getElementById("address").innerHTML += data.address;
        document.getElementById("phone").innerHTML += data.phone;
        document.getElementById("email").innerHTML += data.email;

        // Social Media Links
        document.getElementById("facebook").href = data.facebook;
        document.getElementById("instagram").href = data.instagram;
        document.getElementById("whatsapp").href = data.whatsapp;

    } catch (error) {
        console.error("Error al cargar información del sitio:", error);
    }
}

// Llamar a la función cuando se cargue la página
document.addEventListener("DOMContentLoaded", loadSiteInfo);