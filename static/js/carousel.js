async function loadCarousel() {
    try {
        const response = await fetch("/api/carousel"); // Llamada a la API
        const data = await response.json();

        const container = document.getElementById("carousel-container");
        container.innerHTML = ""; // Limpiar el contenedor

        data.carousel.forEach((slide, index) => {
            const activeClass = index === 0 ? "active" : ""; // La primera diapositiva es 'active'

            const slideHTML = `
                <div class="carousel-item ${activeClass}">
                    <img class="w-100" src="${slide.image_url}" alt="Slide ${slide.id}">
                    <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                        <h2 class="text-primary font-weight-medium m-0">${slide.subtitle}</h2>
                        <h1 class="display-2 text-white m-0">${slide.title}</h1>
                    </div>
                </div>
            `;
            container.innerHTML += slideHTML;
        });
    } catch (error) {
        console.error("Error al cargar el carrusel:", error);
    }
}

document.addEventListener("DOMContentLoaded", loadCarousel);