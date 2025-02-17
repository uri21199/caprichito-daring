from flask import Blueprint, request, session, redirect, url_for, flash, render_template
from werkzeug.security import generate_password_hash
from flask_login import login_required
from models import User
from extensions import db

# Crear el Blueprint para rutas relacionadas con el perfil
profile_bp = Blueprint('profile_bp', __name__)

@profile_bp.route('/profile', methods=['GET'])
@login_required
def serve_profile():
    # Obtener el usuario desde la sesión
    user = User.query.get(session['user_id'])
    if not user:
        flash("Usuario no encontrado.", "danger")
        return redirect(url_for('auth_bp.serve_profile'))
    
    # Renderizar la página de perfil con los datos del usuario
    return render_template('profile.html', user=user)