async function loadProducts() {
    try {
        const response = await fetch("/api/products"); // Ruta que trae productos recomendados
        const data = await response.json();
        const container = document.getElementById("product-container");
        container.innerHTML = ""; // Limpiar el contenedor

        // Recorrer los productos recomendados
        data.products.forEach(product => {
            const productCard = `
                <div class="col-6 col-sm-6 col-md-3 mb-4">
                    <div class="card h-100">
                        <img src="/static/${product.imageurl}" class="card-img-top" alt="${product.name}">
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
document.addEventListener("DOMContentLoaded", loadProducts);

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
        .then((response) => response.json())
        .then((data) => {
            alert(data.message || "Producto añadido al carrito");
            updateCartCount();
        })
        .catch((error) => console.error("Error:", error));
    }
});
