from flask import Blueprint, redirect, url_for, flash, session, render_template, request
from models import User, SiteInfo, Order, OrderItem
from extensions import db
from sqlalchemy.orm import joinedload
from flask_mail import Message
from extensions import mail_ext

admin_bp = Blueprint('admin_bp', __name__)

@admin_bp.route("/admin_dashboard")
def admin_dashboard():
    user = User.query.get(session['user_id'])
    users = User.query.all()
    print(users[-1])
    site_info = SiteInfo.query.all()
    orders = Order.query.options(joinedload(Order.items).joinedload(OrderItem.product)).all()
    return render_template("admin_dash.html", user=user, users=users, site_info=site_info, orders=orders)

from flask import request

@admin_bp.route("/admin_order", methods=["GET", "POST"])
def admin_order():
    try:
        # Obtener información general para la vista
        user = User.query.get(session["user_id"])
        users = User.query.all()
        site_info = SiteInfo.query.all()
        orders = Order.query.all()

        # Manejar solicitudes POST para actualizar órdenes
        if request.method == "POST":
            order_id = request.form.get("order_id")
            action = request.form.get("action")
            print(f"POST Data - Order ID: {order_id}, Action: {action}")

            # Validar si el order_id es válido
            if not order_id:
                flash("ID de orden no proporcionado.", "danger")
                return redirect(url_for('admin_bp.admin_dashboard'))

            # Buscar la orden en la base de datos
            order = Order.query.get(order_id)

            # Validar si la orden existe
            if not order:
                flash("La orden no fue encontrada.", "danger")
                return redirect(url_for('admin_bp.admin_dashboard'))

            # Actualizar el estado según la acción
            if action == "cancelar":
                order.status = "cancelada"
                flash(f"La orden {order_id} ha sido cancelada.", "success")
            elif action == "confirmar":
                order.status = "confirmada"
                store_email = order.user.mail
                msg = Message(
                    subject="Confirmación de Pedido",
                    sender="uri21199@gmail.com",  # O usa MAIL_DEFAULT_SENDER de tu configuración
                    recipients=[store_email]
                )
                msg.body = f"""Estimado/a {order.user.store_name},

                    Su pedido con ID {order.order_id} ha sido confirmado.
                    Total: ${order.total_price}
                    Estado: {order.status}

                    Gracias por su compra.

                    Saludos,
                    El equipo de Caprichito
                """
                mail_ext.send(msg)
                flash(f"La orden {order_id} ha sido confirmada y se envió el correo de confirmación.", "success")
                flash(f"La orden {order_id} ha sido confirmada.", "success")
            else:
                flash("Acción no válida.", "danger")
                return redirect(url_for("admin_order"))

            # Guardar los cambios en la base de datos
            db.session.commit()
            return redirect(url_for("admin_order"))

        # Renderizar la plantilla para GET
        return render_template(
            "admin_dash.html",
            user=user,
            users=users,
            site_info=site_info,
            orders=orders,
        )

    except Exception as e:
        # Capturar errores inesperados y mostrarlos al administrador
        db.session.rollback()  # Revertir cualquier cambio pendiente
        flash(f"Ha ocurrido un error: {str(e)}", "danger")
        return redirect(url_for('admin_bp.admin_dashboard'))



# Ruta para activar un usuario
@admin_bp.route('/admin/users/activate/<int:user_id>', methods=['GET'])
def activate_user(user_id):
    user = User.query.get(user_id)
    if user:
        user.status = 'active'
        db.session.commit()
        flash(f"El usuario {user.mail} ha sido activado con éxito.", "success")
    else:
        flash("Usuario no encontrado.", "danger")
    return redirect(url_for('admin_bp.admin_dashboard'))

# Ruta para desactivar un usuario
@admin_bp.route('/admin/users/deactivate/<int:user_id>', methods=['GET'])
def deactivate_user(user_id):
    user = User.query.get(user_id)
    if user:
        user.status = 'inactive'
        db.session.commit()
        flash(f"El usuario {user.mail} ha sido desactivado con éxito.", "warning")
    else:
        flash("Usuario no encontrado.", "danger")
    return redirect(url_for('admin_bp.admin_dashboard'))

@admin_bp.route('/site_update', methods=['POST'])
def site_update():
    for key, value in request.form.items():
        if key.startswith('value_'):
            id = int(key.split('_')[1])
            site_info = SiteInfo.query.get(id)
            if site_info:
                site_info.value = value
    db.session.commit()
    return redirect(url_for('admin_bp.admin_dashboard'))
