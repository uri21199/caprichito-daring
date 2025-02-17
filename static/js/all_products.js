async function loadAllProducts() {
    try {
        const response = await fetch("/api/all-products"); // Llamar a la API para todos los productos
        const data = await response.json();

        const container = document.getElementById("product-container");
        container.innerHTML = ""; // Limpiar el contenedor

        // Recorrer todos los productos y generar las tarjetas
        data.products.forEach(product => {
            const productCard = `
                <div class="col-6 col-sm-6 col-md-3 mb-4">
                    <div class="card h-100">
                        <img src="/static/${product.imageUrl}" class="card-img-top" alt="${product.name}">
                        <div class="card-body text-center">
                            <h5 class="card-title">${product.name}</h5>
                            ${product.price !== null ? `<p class="card-text">$${product.price}</p>` : ''}
                            <a href="#" class="btn btn-danger btn-sm btn-add-to-cart" data-product-id="${ product.id }">Añadir a carrito</a>
                        </div>
                    </div>
                </div>
            `;
            container.innerHTML += productCard; // Insertar tarjeta en el contenedor
        });

    } catch (error) {
        console.error("Error al cargar productos:", error);
    }
}

// Llamar a la función cuando se cargue la página
document.addEventListener("DOMContentLoaded", loadAllProducts);


document.addEventListener("click", (event) => {
    if (event.target.classList.contains("btn-add-to-cart")) {
        const productId = event.target.dataset.productId;
        
        fetch("/add_to_cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ product_id: productId, quantity: 1 }),
        })
        .then(response => response.json())
        .then(data => {
            console.log("Respuesta del servidor:", data); // 🔹 Depuración en consola
            if (data.redirect) {
                window.location.href = data.redirect;  // 🔹 Redirigir manualmente
            } else if (data.message) {
                alert(data.message);
            }
            updateCartCount();
        })
        .catch(error => console.error("Error:", error));
    }
});
