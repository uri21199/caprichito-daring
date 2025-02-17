async function loadCart() {
    try {
        // Hacer la solicitud a la ruta /cart para obtener los datos del carrito
        const response = await fetch("/cart");
        const data = await response.json();

        const cartProducts = document.getElementById("cart-products");
        const cartTotal = document.getElementById("cart-total");
        const emptyCartButton = document.getElementById("empty-cart-button");

        if (data.cart.length === 0) {
            cartProducts.innerHTML = "<p>Tu carrito está vacío.</p>";
            cartTotal.textContent = "Total: $0";
            emptyCartButton.style.display = "none"; 
        } else {
            cartProducts.innerHTML = ""; // Limpiar productos del carrito
            let total = 0;
    
            // Recorrer los productos en el carrito
            data.cart.forEach((item) => {
                total += item.subtotal;
    
                const productHTML = `
                    <div class="card mb-3">
                        <div class="row no-gutters">
                            <div class="col-md-4">
                                <img src="/static/${item.imageUrl}" class="card-img" alt="${item.product_name}">
                            </div>
                            <div class="col-md-8">
                                <div class="card-body">
                                    <h5 class="card-title">${item.product_name}</h5>
                                    <p class="card-text">Precio: $${item.price}</p>
                                    <div class="d-flex align-items-center">
                                        <button class="btn btn-danger btn-sm btn-remove-from-cart" data-product-id="${item.product_id}">
                                            Eliminar
                                        </button>
                                        <input type="number" class="form-control form-control-sm quantity-input" data-product-id="${item.product_id}" min="1" value="${item.quantity}">
                                    </div>
                                    <p class="mt-2 product-subtotal">Subtotal: $${item.subtotal}</p>
                                </div>
                            </div>
                        </div>
                    </div>
    
                `;
                cartProducts.innerHTML += productHTML;
            });
    
            // Actualizar el total
            cartTotal.textContent = `Total: $${total.toFixed(2)}`;
        }


    } catch (error) {
        console.error("Error al cargar el carrito:", error);
    }
}

// Llamamos a la función para cargar el carrito cuando la página cargue
document.addEventListener("DOMContentLoaded", loadCart);



document.addEventListener('DOMContentLoaded', () => {
    const addToCartButtons = document.querySelectorAll('.btn-add-to-cart');

    addToCartButtons.forEach(button => {
        button.addEventListener('click', async (event) => {
            event.preventDefault();  // Evitar que se recargue la página

            const productId = button.getAttribute('data-product-id');

            try {
                const response = await fetch('/add_to_cart', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        product_id: productId,
                        quantity: 1  // Si deseas permitir que el usuario elija la cantidad, la puedes pasar aquí
                    })
                });

                const data = await response.json();
                if (response.ok) {
                    alert(data.message);  // Mostrar mensaje de éxito
                } else {
                    alert(data.error);  // Mostrar error si ocurre
                }
            } catch (error) {
                console.error('Error al agregar el producto al carrito:', error);
                alert('Hubo un problema al agregar el producto al carrito.');
            }
        });
    });
});


document.addEventListener("click", (event) => {
    if (event.target.classList.contains("btn-remove-from-cart")) {
        const productId = event.target.dataset.productId;

        fetch("/remove_from_cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ product_id: productId }),
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



document.addEventListener("input", (event) => {
    if (event.target.classList.contains("quantity-input")) {
        const productId = event.target.dataset.productId;
        const newQuantity = parseInt(event.target.value, 10);

        if (newQuantity < 1) {
            alert("La cantidad debe ser al menos 1");
            event.target.value = 1; // Reestablecer el valor mínimo
            return;
        }

        fetch("update_quantity", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ product_id: productId, quantity: newQuantity }),
        })
        .then((response) => response.json())
        .then((data) => {
            if (data.message) {
                const productRow = event.target.closest(".card");
                const subtotalElement = productRow.querySelector(".product-subtotal");
                subtotalElement.textContent = `Subtotal: $${data.subtotal.toFixed(2)}`;
                updateCartTotal(); // Recalcular el total del carrito
            } else {
                console.error(data.error);
            }
        })
        .catch((error) => console.error("Error:", error));
    }
});

function updateCartTotal() {
    const subtotalElements = document.querySelectorAll(".product-subtotal");
    let total = 0;

    subtotalElements.forEach((element) => {
        const subtotal = parseFloat(element.textContent.replace("Subtotal: $", ""));
        total += subtotal;
    });

    const cartTotalElement = document.getElementById("cart-total");
    cartTotalElement.textContent = `Total: $${total.toFixed(2)}`;
}


document.addEventListener("DOMContentLoaded", () => {
    const emptyCartButton = document.getElementById("empty-cart-button");

    emptyCartButton.addEventListener("click", async () => {
        Swal.fire({
            title: "¿Estás seguro?",
            text: "Esta acción vaciará todo tu carrito.",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#d33",
            cancelButtonColor: "#3085d6",
            confirmButtonText: "Sí, vaciar carrito",
            cancelButtonText: "Cancelar"
        }).then(async (result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    title: "Vaciando carrito...",
                    text: "Por favor, espera mientras se vacía tu carrito.",
                    icon: "info",
                    allowOutsideClick: false,
                    showConfirmButton: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                try {
                    const response = await fetch("/empty_cart", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json"
                        }
                    });

                    const data = await response.json();
                    Swal.close(); // Cerrar el modal de carga

                    if (response.ok) {
                        Swal.fire({
                            title: "¡Carrito Vacío!",
                            text: data.message,
                            icon: "success",
                            timer: 1200,
                            showConfirmButton: false
                        }).then(() => {
                            window.location.href = "/cart_"; // Redirigir después del mensaje
                        });
                    } else {
                        Swal.fire({
                            title: "Error",
                            text: data.error,
                            icon: "error"
                        });
                    }
                } catch (error) {
                    console.error("Error al vaciar el carrito:", error);
                    Swal.fire({
                        title: "Error",
                        text: "Hubo un problema al vaciar el carrito.",
                        icon: "error"
                    });
                }
            }
        });
    });
});




document.addEventListener("DOMContentLoaded", () => {
    const checkoutButton = document.getElementById("checkout-button");

    checkoutButton.addEventListener("click", async () => {
        Swal.fire({
            title: "Procesando cotización...",
            text: "Por favor, espera mientras se finaliza la cotización.",
            icon: "info",
            allowOutsideClick: false,
            showConfirmButton: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        try {
            const response = await fetch("/send_quote", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                }
            });

            const data = await response.json();
            Swal.close(); // Cerrar el modal de carga

            if (response.ok) {
                Swal.fire({
                    title: "¡Cotización Enviada!",
                    text: data.message,
                    icon: "success",
                    timer: 2000,
                    showConfirmButton: false
                });

                // Recargar el carrito para reflejar que está vacío
                loadCart();
            } else {
                Swal.fire({
                    title: "Error",
                    text: data.error,
                    icon: "error"
                });
            }
        } catch (error) {
            console.error("Error al enviar la cotización:", error);
            Swal.fire({
                title: "Error",
                text: "Hubo un problema al enviar la cotización.",
                icon: "error"
            });
        }
    });
});



async function updateCartCount() {
    try {
        const response = await fetch('/cart_count');
        const data = await response.json();

        const cartCountElement = document.getElementById('cart-count');
        if (data.count > 0) {
            cartCountElement.textContent = data.count; // Mostrar la cantidad
            cartCountElement.style.display = 'inline'; // Mostrar el contador
        } else {
            cartCountElement.style.display = 'none'; // Ocultar el contador si está vacío
        }
    } catch (error) {
        console.error('Error al obtener la cantidad del carrito:', error);
    }
}

// Llamar a la función al cargar la página
document.addEventListener('DOMContentLoaded', updateCartCount);
