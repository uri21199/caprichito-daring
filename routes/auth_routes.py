from flask import Blueprint, render_template, redirect, url_for, flash, jsonify, session, request
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import login_user, logout_user, login_required
from models import User
from extensions import db

auth_bp = Blueprint('auth_bp', __name__)
@auth_bp.route('/user_login', methods=['POST'])
def login():
    email = request.form.get('mail')
    password = request.form.get('password')

    # Buscar al usuario por su correo
    user = User.query.filter_by(mail=email).first()

    # Verificar si el usuario existe y su contraseña es correcta
    if user and check_password_hash(user.password, password):
        # Verificar si el usuario está activo
        if user.status != 'active':
            flash("Su usuario está pendiente de aprobación.", "warning")
            return redirect(url_for('serve_index'))  # Redirige a la página de login
        
        # Iniciar sesión si el usuario está activo
        session['user_id'] = user.id
        session['logged_in'] = True
        session['role'] = user.role

        flash("Inicio de sesión exitoso", "success")  # Mensaje Flash
        return redirect(url_for('serve_index'))  # Redirige al índice
    else:
        flash("Correo o contraseña incorrectos", "danger")
        return redirect(url_for('serve_index'))
