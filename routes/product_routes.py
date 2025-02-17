from flask import Blueprint, jsonify, session
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
            "imageUrl": product.imageUrl
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
            "imageUrl": product.imageUrl
        }
        for product in products
    ]
    return jsonify({"products": products_list})  # Devolver como JSON
