from flask import Blueprint, render_template, request, redirect, url_for, flash
from werkzeug.security import generate_password_hash
from models import User
from flask_mail import Message
from extensions import mail_ext
from extensions import db

register_bp = Blueprint('register_bp', __name__)

@register_bp.route('/register', methods=['GET', 'POST'])
def register_user():
    if request.method == 'POST':
        # Manejo del registro de usuario
        store_name = request.form.get('store_name')
        mail_form = request.form.get('mail')
        password = request.form.get('password')
        cuit = request.form.get('cuit')
        province = request.form.get('province')
        city = request.form.get('city')
        # Validar si ya existe un usuario con ese correo
        existing_user = User.query.filter_by(mail=mail_form).first()
        if existing_user:
            flash("El correo ya está registrado. Intenta con otro.", "danger")
            return redirect(url_for('register_bp.register_user'))
        # Crear y guardar el nuevo usuario
        hashed_password = generate_password_hash(password, method='pbkdf2:sha256')
        new_user = User(
            store_name=store_name,
            mail=mail_form,
            password=hashed_password,
            cuit=cuit,
            province=province,
            city=city,
            role='user',  # Rol por defecto
            status='inactive') # Estado inactivo por defecto hasta aceptación de Caprichito
        db.session.add(new_user)
        db.session.commit()

        msg = Message(
            subject="Nuevo Registro de Usuario",
            sender='uri21199@gmail.com',  # Reemplázalo por tu correo
            recipients=['lautarouab@gmail.com']  # Correo del administrador
        )

        msg.body = f"""
        Un nuevo usuario se ha registrado:
        - Nombre de la tienda: {store_name}
        - Correo Electrónico: {mail_form}
        - CUIT: {cuit}
        - Provincia: {province if province else 'No especificado'}
        - Ciudad: {city if city else 'No especificado'}
        """
        mail_ext.send(msg)

        flash("Registro enviado. Será notificado de la validación", "success")
        return redirect(url_for('serve_index'))
    return render_template('register.html')
