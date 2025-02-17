from flask import Blueprint, request, session, redirect, url_for, flash
from werkzeug.security import generate_password_hash
from flask_login import login_required
from models import User
from extensions import db

# Crear el Blueprint para la ruta profile_update
profile_update_bp = Blueprint('profile_update_bp', __name__)

@profile_update_bp.route('/profile_update', methods=['POST'])
#@login_required
def profile_update():
    # Obtener el usuario desde la sesión
    user = User.query.get(session['user_id'])
    if not user:
        flash("Usuario no encontrado.", "danger")
        return redirect(url_for('serve_index'))
    
    try:
        # Actualizar los campos del usuario
        user.store_name = request.form.get('store_name')
        user.mail = request.form.get('mail')
        user.cuit = request.form.get('cuit')
        user.province = request.form.get('province')
        user.city = request.form.get('city')
        user.phone = request.form.get('phone')
        user.address = request.form.get('address')
        user.website = request.form.get('website')

        # Actualizar la contraseña solo si se proporciona
        password = request.form.get('password')
        if password:
            user.password = generate_password_hash(password)
        
        # Guardar los cambios
        db.session.add(user)  # Esto asegura que SQLAlchemy rastree el objeto
        db.session.commit()
        flash("Perfil actualizado exitosamente.", "success")
    except Exception as e:
        db.session.rollback()
        flash(f"Error al actualizar el perfil: {e}", "danger")

    return redirect(url_for('serve_index'))
