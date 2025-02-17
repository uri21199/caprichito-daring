from flask import Blueprint, request, session, jsonify
from models import db, Order, OrderItem, Cart, CartItem
from sqlalchemy.exc import SQLAlchemyError

order_bp = Blueprint('order_bp', __name__)

@order_bp.route('/create_order', methods=['POST'])
def create_order():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({"error": "Usuario no autenticado"}), 401

    # Buscar el carrito del usuario
    cart = Cart.query.filter_by(user_id=user_id).first()
    if not cart or not cart.cart_items:
        return jsonify({"error": "El carrito está vacío"}), 400

    try:
        # Crear una nueva orden
        total = sum(item.quantity * item.product.price for item in cart.cart_items)
        new_order = Order(user_id=user_id, total_price=total)
        db.session.add(new_order)
        db.session.commit()

        # Crear los items de la orden
        for cart_item in cart.cart_items:
            order_item = OrderItem(
                order_id=new_order.order_id,
                product_id=cart_item.product_id,
                quantity=cart_item.quantity,
                price=cart_item.quantity * cart_item.product.price
            )
            db.session.add(order_item)
        
        # Vaciar el carrito
        CartItem.query.filter_by(cart_id=cart.cart_id).delete()
        db.session.commit()

        return jsonify({"message": "Orden creada correctamente", "order_id": new_order.order_id}), 201

    except SQLAlchemyError as e:
        db.session.rollback()
        return jsonify({"error": "Error al crear la orden", "details": str(e)}), 500


@order_bp.route('/my_orders', methods=['GET'])
def get_my_orders():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({"error": "Usuario no autenticado"}), 401

    orders = Order.query.filter_by(user_id=user_id).all()
    return jsonify([{
        "order_id": order.order_id,
        "created_at": order.created_at.strftime('%Y-%m-%d %H:%M:%S'),
        "total_price": order.total_price,
        "status": order.status,
        "items": [{
            "product_id": item.product_id,
            "quantity": item.quantity,
            "subtotal": item.subtotal
        } for item in order.items]
    } for order in orders]), 200



@order_bp.route('/all_orders', methods=['GET'])
def get_all_orders():
    # Aquí puedes verificar si el usuario tiene permisos de administrador
    if session.get('role') != 'admin':
        return jsonify({"error": "Acceso denegado"}), 403

    orders = Order.query.all()
    return jsonify([{
        "order_id": order.order_id,
        "user_id": order.user_id,
        "created_at": order.created_at.strftime('%Y-%m-%d %H:%M:%S'),
        "total_price": order.total_price,
        "status": order.status,
        "items": [{
            "product_id": item.product_id,
            "quantity": item.quantity,
            "subtotal": item.subtotal
        } for item in order.items]
    } for order in orders]), 200
