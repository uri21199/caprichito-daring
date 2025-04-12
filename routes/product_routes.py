from flask import Blueprint, jsonify, session, request
from extensions import db
from models import Product

# Crear un Blueprint para las rutas de productos
product_bp = Blueprint('product_bp', __name__)

# Ruta para obtener todos los productos
@product_bp.route('/api/products', methods=['GET'])
def get_products():
    products = Product.query.filter_by(recommended=True).all() # Consultar todos los productos
    is_logged_in = session.get('logged_in', False)  
    # Convertir los productos a un formato JSON
    products_list = [
        {
            "id": product.product_id,
            "name": product.name,
            "description": product.description,
            "price": float(product.price) if is_logged_in else None,
            "promotion": float(product.promotion) if product.promotion else None,
            "imageurl": product.imageurl
        }
        for product in products
    ]
    return jsonify({"products": products_list})  # Devolver como JSON


@product_bp.route('/api/all-products', methods=['GET'])
def get_all_products():
    products = Product.query.all()  # Consultar todos los productos
    is_logged_in = session.get('logged_in', False)
    products_list = [
        {
            "id": product.product_id,
            "name": product.name,
            "description": product.description,
            "price": float(product.price) if is_logged_in else None, 
            "promotion": float(product.promotion) if product.promotion else None,
            "imageurl": product.imageurl
        }
        for product in products
    ]
    return jsonify({"products": products_list})  # Devolver como JSON


@product_bp.route('/api/toggle-product/<int:product_id>', methods=['POST'])
def toggle_product_status(product_id):
    product = Product.query.get(product_id)
    
    if not product:
        return jsonify({"error": "Producto no encontrado"}), 404

    new_status = request.json.get("status")
    if new_status not in ["available", "inactive"]:
        return jsonify({"error": "Estado inválido"}), 400

    product.status = new_status
    db.session.commit()

    return jsonify({"message": f"Producto {new_status} correctamente"}), 200

@product_bp.route('/api/update-product/<int:product_id>', methods=['POST'])
def update_product(product_id):
    product = Product.query.get(product_id)
    
    if not product:
        return jsonify({"error": "Producto no encontrado"}), 404

    data = request.json
    field = data.get("field")
    value = data.get("value")

    # Validar si el campo es válido
    allowed_fields = ["name", "description", "price", "promotion"]
    if field not in allowed_fields:
        return jsonify({"error": "Campo no permitido"}), 400

    # Convertir a tipo correcto si es necesario
    if field == "price":
        try:
            value = float(value)
        except ValueError:
            return jsonify({"error": "El precio debe ser un número válido"}), 400

    if field == "promotion":
        value = 1 if value.lower() == "sí" else 0

    setattr(product, field, value)  # Actualizar campo dinámicamente
    db.session.commit()

    return jsonify({"message": f"Campo {field} actualizado correctamente"}), 200
