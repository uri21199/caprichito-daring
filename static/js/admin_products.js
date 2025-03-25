document.addEventListener("DOMContentLoaded", () => {
    loadProducts();
});

// Función para obtener los productos desde la API y cargarlos en la tabla
async function loadProducts() {
    try {
        const response = await fetch('/api/all-products');
        const data = await response.json();

        if (response.ok) {
            const productsTable = document.querySelector("#products-table tbody");
            productsTable.innerHTML = ""; // Limpiar la tabla antes de insertar datos

            data.products.forEach(product => {
                const row = document.createElement("tr");

                row.innerHTML = `
                    <td>${product.id}</td>
                    <td contenteditable="true" class="editable" data-id="${product.id}" data-field="name">${product.name}</td>
                    <td contenteditable="true" class="editable" data-id="${product.id}" data-field="description">${product.description}</td>
                    <td contenteditable="true" class="editable" data-id="${product.id}" data-field="price">
                        ${product.price !== null ? `$${product.price.toFixed(2)}` : "🔒"}
                    </td>
                    <td contenteditable="true" class="editable" data-id="${product.id}" data-field="promotion">${product.promotion ? "✅ Sí" : "❌ No"}</td>
                    <td>
                        <span class="badge ${product.status === 'available' ? 'bg-success' : 'bg-danger'}">
                            ${product.status}
                        </span>
                    </td>
                    <td>
                        <button class="btn btn-sm ${product.status === 'available' ? 'btn-danger' : 'btn-success'} toggle-status"
                            data-id="${product.id}" data-status="${product.status}">
                            ${product.status === 'available' ? 'Desactivar' : 'Activar'}
                        </button>
                    </td>
                `;
                productsTable.appendChild(row);
            });

            // Agregar eventos a los botones de activar/desactivar
            document.querySelectorAll(".toggle-status").forEach(button => {
                button.addEventListener("click", toggleProductStatus);
            });

            // Agregar eventos para editar celdas en vivo
            document.querySelectorAll(".editable").forEach(cell => {
                cell.addEventListener("blur", updateProductField);
            });

        } else {
            console.error("Error al obtener productos:", data.error);
        }
    } catch (error) {
        console.error("Error al cargar productos:", error);
    }
}

// Función para actualizar un campo en la base de datos cuando se edita
async function updateProductField(event) {
    const cell = event.target;
    const productId = cell.dataset.id;
    const field = cell.dataset.field;
    const newValue = cell.textContent.trim();

    try {
        const response = await fetch(`/api/update-product/${productId}`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ field, value: newValue })
        });

        const data = await response.json();
        if (!response.ok) {
            Swal.fire({ title: "Error", text: data.error, icon: "error" });
        }
    } catch (error) {
        Swal.fire({ title: "Error", text: "No se pudo actualizar el producto", icon: "error" });
    }
}
