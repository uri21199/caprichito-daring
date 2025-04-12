from flask import Blueprint, session, jsonify, redirect, request, make_response, flash, url_for, current_app
from flask_mail import Message
from extensions import db, mail_ext
from models import Cart, CartItem, Product, User, Order, OrderItem  # Asegúrate de importar tus modelos
import threading

cart_bp = Blueprint('cart', __name__)

@cart_bp.route('/cart', methods=['GET'])
def get_cart():
    # Obtén el ID del usuario desde la sesión
    user_id = session.get('user_id')
    if not user_id:
        return redirect('/login')  # Redirigir si no está autenticado

    # Buscar el carrito del usuario
    cart = Cart.query.filter_by(user_id=user_id).first()

    if not cart:
        # Si no hay carrito, devuelve un carrito vacío
        return jsonify({"cart": [], "total": 0})

    # Obtener los productos del carrito
    items = [
        {
            "product_id": item.product_id,
            "product_name": item.product.name,
            "price": float(item.product.price),
            "subtotal": float(item.quantity * item.product.price),
            "imageurl": item.product.imageurl,  # Asegúrate de que el producto tiene esta propiedad
            "quantity": item.quantity
        }
        for item in cart.cart_items
    ]

    # Calcular el total del carrito
    total = sum(item['subtotal'] for item in items)

    # Devolver los datos del carrito en formato JSON
    return jsonify({"cart": items, "total": total})


@cart_bp.route('/add_to_cart', methods=['POST'])
def add_to_cart():
    user_id = session.get('user_id')
    if not user_id:
        flash("Debes iniciar sesión para agregar productos al carrito.", "danger")
        return jsonify({"redirect": url_for('serve_login')}), 401

    product_id = request.json.get('product_id')
    quantity = request.json.get('quantity', 1)

    product = Product.query.get(product_id)
    if not product:
        flash("Producto no encontrado.", "danger")
        return jsonify({"redirect": url_for('productos')}), 404

    # Buscar o crear carrito
    cart = Cart.query.filter_by(user_id=user_id).first()
    if not cart:
        cart = Cart(user_id=user_id)
        db.session.add(cart)
        db.session.commit()

    # Verificar si el producto ya está en el carrito
    cart_item = CartItem.query.filter_by(cart_id=cart.cart_id, product_id=product_id).first()
    if cart_item:
        cart_item.quantity += quantity
    else:
        cart_item = CartItem(cart_id=cart.cart_id, product_id=product_id, quantity=quantity)
        db.session.add(cart_item)

    db.session.commit()

    flash("Producto agregado al carrito exitosamente.", "success")

    return jsonify({"redirect": url_for('serve_productos')})  # 🔹 Devuelve la URL como string


@cart_bp.route('/remove_from_cart', methods=['POST'])
def remove_from_cart():
    user_id = session.get('user_id')
    if not user_id:
        flash("Debes iniciar sesión para gestionar tu carrito.", "danger")
        return jsonify({"redirect": url_for('serve_index')}), 401

    product_id = request.json.get('product_id')
    if not product_id:
        flash("Error: ID del producto no proporcionado.", "danger")
        return jsonify({"redirect": url_for('serve_productos')}), 400

    # Buscar el carrito del usuario
    cart = Cart.query.filter_by(user_id=user_id).first()
    if not cart:
        flash("Error: Carrito no encontrado.", "danger")
        return jsonify({"redirect": url_for('serve_productos')}), 404

    # Buscar el ítem en el carrito
    cart_item = CartItem.query.filter_by(cart_id=cart.cart_id, product_id=product_id).first()
    if cart_item:
        db.session.delete(cart_item)
        db.session.commit()
        flash("Producto eliminado del carrito exitosamente.", "success")
        return jsonify({"redirect": url_for('serve_cart')})  # Redirigir para mostrar el mensaje
    else:
        flash("Error: Producto no encontrado en el carrito.", "danger")
        return jsonify({"redirect": url_for('serve_cart')}), 404




@cart_bp.route('/update_quantity', methods=['POST'])
def update_quantity():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({"error": "Usuario no autenticado"}), 401

    product_id = request.json.get('product_id')
    quantity = request.json.get('quantity')

    if not product_id or not quantity:
        return jsonify({"error": "Datos incompletos"}), 400

    if quantity < 1:
        return jsonify({"error": "La cantidad debe ser mayor o igual a 1"}), 400

    # Buscar el carrito del usuario
    cart = Cart.query.filter_by(user_id=user_id).first()
    if not cart:
        return jsonify({"error": "Carrito no encontrado"}), 404

    # Buscar el item en el carrito
    cart_item = CartItem.query.filter_by(cart_id=cart.cart_id, product_id=product_id).first()
    if cart_item:
        cart_item.quantity = quantity
        db.session.commit()
        return jsonify({"message": "Cantidad actualizada correctamente", "subtotal": float(cart_item.quantity * cart_item.product.price)}), 200
    else:
        return jsonify({"error": "Producto no encontrado en el carrito"}), 404


@cart_bp.route('/empty_cart', methods=['POST'])
def empty_cart():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({"error": "Usuario no autenticado"}), 401

    cart = Cart.query.filter_by(user_id=user_id).first()
    if cart and cart.cart_items:
        # Eliminación masiva en lugar de un loop, más rápido
        CartItem.query.filter_by(cart_id=cart.cart_id).delete()
        db.session.commit()
        print("✅ Carrito vaciado correctamente")
        return jsonify({"message": "Carrito vaciado correctamente"}), 200

    return jsonify({"error": "El carrito ya estaba vacío"}), 400



def send_email_async(app, msg):
    with app.app_context():
        try:
            mail_ext.send(msg)
            print("✅ Correo enviado correctamente")
        except Exception as e:
            print(f"❌ Error al enviar correo: {e}")

@cart_bp.route('/send_quote', methods=['POST'])
def send_quote():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({"error": "Usuario no autenticado"}), 401

    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "Usuario no encontrado"}), 404

    cart = Cart.query.filter_by(user_id=user_id).first()
    if not cart or not cart.cart_items:
        return jsonify({"error": "El carrito está vacío"}), 400

    cart_items = []
    total = 0
    for item in cart.cart_items:
        subtotal = item.quantity * item.product.price
        cart_items.append({
            "name": item.product.name,
            "price": item.product.price,
            "quantity": item.quantity,
            "product_id": item.product_id,
            "subtotal": subtotal
        })
        total += subtotal

    new_order = Order(
        user_id=user_id,
        total_price=total,
        status="Pendiente",
        cart_id=cart.cart_id
    )
    db.session.add(new_order)
    db.session.commit()

    for item in cart_items:
        order_item = OrderItem(
            order_id=new_order.order_id,
            product_id=item['product_id'],
            quantity=item['quantity'],
            price=item['subtotal']
        )
        db.session.add(order_item)
    db.session.commit()

    cart_details = "\n".join([
        f"- {item['name']} (x{item['quantity']}): ${item['subtotal']:.2f}"
        for item in cart_items
    ])
    
    email_body = f"""
    Cotización realizada:
    Número de carrito: {cart.cart_id}
    Usuario: {user.store_name} ({user.mail})
    
    Productos:
    {cart_details}

    Total: ${total:.2f}
    """

    msg = Message(
        subject="Nueva Cotización",
        sender="uri21199@gmail.com",
        recipients=["lautarouab@gmail.com"]
    )
    msg.body = email_body

    # Enviar el correo en un HILO para evitar bloqueos
    thread = threading.Thread(target=send_email_async, args=(current_app._get_current_object(), msg))
    thread.start()

    # Vaciar el carrito después de enviar la cotización
    for item in cart.cart_items:
        db.session.delete(item)
    db.session.commit()

    return jsonify({"message": "Cotización enviada correctamente"}), 200



@cart_bp.route('/cart_count', methods=['GET'])
def cart_count():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({"count": 0})  # Si el usuario no está autenticado, devolver 0

    cart = Cart.query.filter_by(user_id=user_id).first()
    if not cart or not cart.cart_items:
        return jsonify({"count": 0})  # Si el carrito está vacío, devolver 0

    total_count = sum(item.quantity for item in cart.cart_items)
    response = make_response(jsonify({"count": total_count}))
    response.headers['Cache-Control'] = 'no-store'
    return response