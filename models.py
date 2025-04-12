from extensions import db
from flask_login import UserMixin
from sqlalchemy.orm import relationship

# Modelo para la tabla 'products'
class Product(db.Model):
    __tablename__ = 'products'

    product_id = db.Column(db.Integer, primary_key=True)
    category_id = db.Column(db.Integer)
    name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text)
    price = db.Column(db.Numeric(10, 2), nullable=False)
    status = db.Column(db.String(50), default="available")
    recommended = db.Column(db.Boolean(), nullable=False, default=False)
    promotion = db.Column(db.Numeric(10, 2))
    imageurl = db.Column(db.String(255))
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())

    def __repr__(self):
        return f"<Product {self.name}>"


class Carousel(db.Model):
    __tablename__ = 'carousel'

    id = db.Column(db.Integer, primary_key=True)
    image_url = db.Column(db.String(255), nullable=False)
    title = db.Column(db.String(255), nullable=False)
    subtitle = db.Column(db.String(255), nullable=True)
    active = db.Column(db.Boolean(), nullable=False, default=True)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())

    def __repr__(self):
        return f"<Carousel {self.title}>"
    

class SiteInfo(db.Model):
    __tablename__ = 'site_info'

    id = db.Column(db.Integer, primary_key=True)
    key_name = db.Column(db.String(50), nullable=False, unique=True)
    value = db.Column(db.String(255), nullable=False)
    def __repr__(self):
        return f"<SiteInfo {self.key_name}: {self.value}>"


class User(db.Model, UserMixin):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    store_name = db.Column(db.String(50), unique=True, nullable=False)
    mail = db.Column(db.String(255), nullable=False)
    password = db.Column(db.String(255), nullable=False)  # La contraseña debe estar encriptada
    cuit = db.Column(db.String(50), nullable=False)
    province = db.Column(db.String(50), nullable=False)
    city = db.Column(db.String(255), nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    address = db.Column(db.String(255), nullable=False)
    website = db.Column(db.String(255), nullable=False)
    role = db.Column(db.Enum('admin', 'user', name='role_enum'), default='user', nullable=False)
    comprador = db.Column(db.String(255), nullable=True)
    status = db.Column(db.Enum('active', 'inactive', name='status_enum'), default='inactive', nullable=False)
    def __repr__(self):
        return f"<User {self.store_name}>"

class Branch(db.Model):
    __tablename__ = 'branches'

    branch_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    
    branchname = db.Column(db.String(100), nullable=False)
    mail = db.Column(db.String(200))
    cuit = db.Column(db.String(20))
    store_name = db.Column(db.String(255))
    province = db.Column(db.String(200))
    city = db.Column(db.String(100))
    address = db.Column(db.String(200))
    phone = db.Column(db.String(20))
    website = db.Column(db.String(200))
    status = db.Column(db.String(50))
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    
    # Relación con la tabla "users"
    user = db.relationship("User", backref=db.backref("branches", lazy=True))
    def __repr__(self):
        return f"<Branch branch_id={self.branch_id} branchname={self.branchname}>"


class Cart(db.Model):
    __tablename__ = 'cart'

    cart_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, nullable=False, unique=True)  # Un carrito por usuario
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())

    # Relación con los cart_items
    cart_items = db.relationship('CartItem', backref='cart', cascade="all, delete-orphan")



class CartItem(db.Model):
    __tablename__ = 'cart_item'

    cartitem_id = db.Column(db.Integer, primary_key=True)
    cart_id = db.Column(db.Integer, db.ForeignKey('cart.cart_id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('products.product_id'), nullable=False)
    quantity = db.Column(db.Integer, default=1, nullable=False)

    product = db.relationship('Product')

class Order(db.Model):
    __tablename__ = 'orders'
    order_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)  # Clave foránea
    cart_id = db.Column(db.Integer, nullable=False)
    total_price = db.Column(db.Numeric(10, 2), nullable=False)
    status = db.Column(db.String(50), default="Pendiente", nullable=False)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    
    # Relación con User
    user = db.relationship('User', backref=db.backref('orders', lazy=True))
    
    # Relación con OrderItem
    items = db.relationship('OrderItem', back_populates='order', lazy='select')

class OrderItem(db.Model):
    __tablename__ = 'order_item'
    orderitem_id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey('orders.order_id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('products.product_id'), nullable=False)
    quantity = db.Column(db.Integer, default=1, nullable=False)
    price = db.Column(db.Numeric(10, 2), nullable=False)  # Precio en el momento de la compra
    
    # Relación con Order
    order = db.relationship('Order', back_populates='items')
    
    # Relación con Product
    product = db.relationship('Product', backref=db.backref('order_items', lazy=True))
