from flask import Flask, send_from_directory, session, redirect, url_for, render_template, flash, request, jsonify
from config import Config
from flask_mail import Mail, Message
from extensions import db, login_manager
from routes.product_routes import product_bp
from routes.carousel_routes import carousel_bp
from routes.site_info_routes import site_info_bp
from routes.auth_routes import auth_bp
from routes.admin_routes import admin_bp
from routes.profile_routes import profile_bp
from routes.profile_update_routes import profile_update_bp
from routes.register_routes import register_bp
from routes.cart_routes import cart_bp
from models import User, Order, Cart
from extensions import mail_ext
from flask_mail import Mail
import os
import psycopg2
import psycopg2.extensions
import psycopg2.extras

psycopg2.extensions.register_type(psycopg2.extensions.new_type((16,), "BOOLEAN", psycopg2.STRING))

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # Inicializar la base de datos
    db.init_app(app)
    login_manager.init_app(app)
    mail_ext.init_app(app)

    # Configuración de redirección de login
    login_manager.login_view = "serve_login"
    login_manager.login_message = "Por favor, inicia sesión para acceder a esta página."

    @login_manager.user_loader
    def load_user(user_id):
        return User.query.get(int(user_id))

    with app.app_context():
        db.create_all()

    # Registrar Blueprints
    app.register_blueprint(product_bp)
    app.register_blueprint(carousel_bp)
    app.register_blueprint(site_info_bp)
    app.register_blueprint(auth_bp, url_prefix='/auth')
    app.register_blueprint(admin_bp)
    app.register_blueprint(profile_bp, url_prefix='/profile')
    app.register_blueprint(register_bp, url_prefix='/register')
    app.register_blueprint(profile_update_bp)
    app.register_blueprint(cart_bp)

    # Rutas
    @app.route("/")
    def serve_index():
        user_id = session.get('user_id')
        total_count = 0
        if user_id:
            cart = Cart.query.filter_by(user_id=user_id).first()
            if cart and cart.cart_items:
                total_count = sum(item.quantity for item in cart.cart_items)
        return render_template("index.html", total_count=total_count)

    @app.route("/productos")
    def serve_productos():
        user_id = session.get('user_id')
        total_count = 0
        if user_id:
            cart = Cart.query.filter_by(user_id=user_id).first()
            if cart and cart.cart_items:
                total_count = sum(item.quantity for item in cart.cart_items)
        return render_template("productos.html", total_count=total_count)

    @app.route("/nosotros")
    def serve_nosotros():
        user_id = session.get('user_id')
        total_count = 0
        if user_id:
            cart = Cart.query.filter_by(user_id=user_id).first()
            if cart and cart.cart_items:
                total_count = sum(item.quantity for item in cart.cart_items)
        return render_template("nosotros.html", total_count=total_count)

    @app.route("/servicio")
    def serve_servicio():
        user_id = session.get('user_id')
        total_count = 0
        if user_id:
            cart = Cart.query.filter_by(user_id=user_id).first()
            if cart and cart.cart_items:
                total_count = sum(item.quantity for item in cart.cart_items)
        return render_template("servicio.html", total_count=total_count)

    @app.route("/contacto")
    def serve_contacto():
        user_id = session.get('user_id')
        total_count = 0
        if user_id:
            cart = Cart.query.filter_by(user_id=user_id).first()
            if cart and cart.cart_items:
                total_count = sum(item.quantity for item in cart.cart_items)
        return render_template('contacto.html', total_count=total_count)
    
    @app.route("/register_route")
    def serve_register():
        user_id = session.get('user_id')
        total_count = 0
        if user_id:
            cart = Cart.query.filter_by(user_id=user_id).first()
            if cart and cart.cart_items:
                total_count = sum(item.quantity for item in cart.cart_items)
        return render_template("register.html", total_count=total_count)
    
    @app.route('/profile')
    def serve_profile():
        if 'user_id' in session:  # Verifica si el usuario está autenticado
            user = User.query.get(session['user_id'])  # Obtén el usuario autenticado por su ID
            
            if user:
                # Obtén las órdenes del usuario autenticado
                orders = Order.query.filter_by(user_id=user.id).all()
                
                # Renderiza la plantilla, pasando el usuario y sus órdenes
                return render_template('profile.html', user=user, orders=orders)
        
        flash("Debes iniciar sesión para acceder a esta página.", "danger")
        return redirect(url_for('serve_index'))


    
    @app.route("/login")
    def serve_login():
        user_id = session.get('user_id')
        total_count = 0
        if user_id:
            cart = Cart.query.filter_by(user_id=user_id).first()
            if cart and cart.cart_items:
                total_count = sum(item.quantity for item in cart.cart_items)
        return render_template("login.html", total_count=total_count)
    
    @app.route('/logout')
    def logout():
        session.clear()
        #flash("Sesión cerrada exitosamente", "success")
        return redirect(url_for('serve_index'))  # Redirige al endpoint correcto
    
    @app.route("/cart_")
    def serve_cart():
        user_id = session.get('user_id')
        total_count = 0
        if user_id:
            cart = Cart.query.filter_by(user_id=user_id).first()
            if cart and cart.cart_items:
                total_count = sum(item.quantity for item in cart.cart_items)
        return render_template("carrito.html", total_count=total_count)

    @app.route('/check_session')
    def check_session():
        if session.get('logged_in'):
            return "Sesión activa", 200
        else:
            return "No hay sesión activa", 200


    @app.route("/send_email", methods=["POST"])
    def send_email():
        name = request.form.get("name")
        email = request.form.get("email")
        subject = request.form.get("subject")
        message = request.form.get("message")

        if not (name and email and subject and message):
            return jsonify({"error": "Todos los campos son obligatorios"}), 400

        try:
            msg = Message(
                subject=f"Nuevo mensaje de contacto: {subject}",
                sender=email,
                recipients=["lautarouab@gmail.com"]
            )
            msg.body = f"""
            Nombre: {name}
            Email: {email}
            Asunto: {subject}

            Mensaje:
            {message}
            """

            # Usamos mail_ext para enviar el correo
            mail_ext.send(msg)

            return jsonify({"message": "Correo enviado correctamente"}), 200

        except Exception as e:
            return jsonify({"error": f"Error al enviar el correo: {str(e)}"}), 500



    return app

app = create_app()  # ← 🔥 Esto le permite a Gunicorn encontrar la app

if __name__ == "__main__":
    app.run()
