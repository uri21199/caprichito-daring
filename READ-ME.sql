-- Query SQL para cargar productos y variaciones:
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    promotion DECIMAL(10,2),
    imageUrl VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO products (name, description, price, promotion, imageUrl)
VALUES
('Pelota de Caucho', 'Pelota resistente para perros', 500.00, 450.00, 'img/pelota-caucho.jpg'),
('Hueso de Juguete', 'Hueso masticable para perros', 350.00, NULL, 'img/hueso-juguete.jpg'),
('Rascador para Gatos', 'Rascador vertical para gatos', 1500.00, 1300.00, 'img/rascador-gatos.jpg'),
('Juguete con Sonido', 'Juguete con sonido para entretenimiento de mascotas', 700.00, 650.00, 'img/juguete-sonido.jpg'),
('Cama Acolchada', 'Cama acolchada para mascotas pequeñas y medianas', 2500.00, 2200.00, 'img/cama-mascotas.jpg'),
('Globo Metalizado', 'Globos metalizados con formas divertidas', 120.00, 100.00, 'img/globo-metalizado.jpg'),
('Confeti en Bolsa', 'Bolsa grande de confeti de papel', 80.00, NULL, 'img/confeti-bolsa.jpg'),
('Sombrero de Fiesta', 'Sombrero colorido para celebraciones', 150.00, 120.00, 'img/sombrero-fiesta.jpg'),
('Guirnalda Decorativa', 'Guirnalda con luces LED para fiestas', 1800.00, 1600.00, 'img/guirnalda-luces.jpg'),
('Piñata Grande', 'Piñata en forma de estrella, ideal para fiestas infantiles', 2200.00, 2000.00, 'img/pinata-grande.jpg');

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- Nombre de la categoría
    description TEXT                   -- Descripción opcional
);

ALTER TABLE products ADD FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL;

CREATE TABLE product_variations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    variation_name VARCHAR(100) NOT NULL, -- Nombre de la variación (ej: "Color", "Tamaño")
    variation_value VARCHAR(100) NOT NULL, -- Valor de la variación (ej: "Rojo", "Bolson")
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);
INSERT INTO product_variations (product_id, variation_name, variation_value)
VALUES
(1, 'Color', 'Rojo'),
(1, 'Color', 'Azul'),
(2, 'Tamaño', 'Pequeño'),
(2, 'Tamaño', 'Grande'),
(3, 'Altura', '60 cm'),
(3, 'Altura', '120 cm'),
(6, 'Forma', 'Estrella'),
(6, 'Forma', 'Corazón'),
(9, 'Longitud', '5 metros'),
(9, 'Longitud', '10 metros');

CREATE TABLE carousel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    image_url VARCHAR(255) NOT NULL, -- URL o ruta de la imagen
    title VARCHAR(100),             -- Título principal
    subtitle VARCHAR(255),          -- Subtítulo o texto secundario
    active BOOLEAN DEFAULT FALSE,   -- Define si la imagen está activa en el carrusel
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO carousel (image_url, title, subtitle, active)
VALUES 
('img/carrusel-1.jpg', 'Bienvenidos a Caprichito', 'La mejor tienda mayorista para mascotas y cotillón.', TRUE),
('img/carrusel-2.jpg', 'Nuevos Productos', 'Descubre nuestras ofertas en juguetes y accesorios.', TRUE),
('img/carrusel-3.jpg', 'Cotillón de Calidad', 'Artículos para tus fiestas y eventos especiales.', TRUE);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,  -- Nombre de usuario
    mail VARCHAR(255) UNIQUE NOT NULL,     -- Mail de usuario
    password VARCHAR(255) NOT NULL,        -- Contraseña (encriptada más adelante)
    cuit VARCHAR(50) UNIQUE NOT NULL,      -- CUIT para verificar el comercio
    provincia VARCHAR(50) NOT NULL,        -- Provincia de la tienda
    ciudad VARCHAR(255) NOT NULL,          -- Ciudad de la tienda
    phone VARCHAR(20),                     -- Teléfono de contacto
    address VARCHAR(255),                  -- Dirección física de la tienda
    website VARCHAR(255),                  -- Sitio web de la tienda
    role ENUM('admin', 'user') DEFAULT 'user', -- Rol: admin o user
    status ENUM('active', 'inactive') DEFAULT 'active', -- Estado del usuario
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO users (username, mail, password, cuit, provincia, ciudad, phone, address, website, role, status)
VALUES
('admin', 'admin@caprichito.com', '123456', '20-12345678-9', 'Buenos Aires', 'CABA', '+54 11 1234-5678', 'Av. Siempre Viva 742', 'https://www.caprichito.com', 'admin', 'active'),
('tienda1', 'tienda1@mail.com', 'password1', '30-87654321-0', 'Córdoba', 'Córdoba Capital', '+54 351 555-1234', 'Calle Falsa 123', NULL, 'user', 'active'),
('tienda2', 'tienda2@mail.com', 'password2', '27-11223344-5', 'Santa Fe', 'Rosario', '+54 341 678-5678', 'Bv. Oroño 456', 'https://www.tienda2.com', 'user', 'active'),
('tienda3', 'tienda3@mail.com', 'password3', '23-44556677-1', 'Mendoza', 'Mendoza Capital', '+54 261 123-9876', 'Av. San Martín 789', NULL, 'user', 'inactive'),
('tienda4', 'tienda4@mail.com', 'password4', '26-99887766-4', 'Buenos Aires', 'Mar del Plata', '+54 223 987-4567', 'Calle 100 N° 200', 'https://www.tienda4.com', 'user', 'active');


CREATE TABLE site_info (
    id INT AUTO_INCREMENT PRIMARY KEY,
    key_name VARCHAR(100) UNIQUE NOT NULL, -- Clave que identifica el dato (ej: "facebook", "instagram")
    value TEXT NOT NULL                   -- Valor asociado a la clave
);
INSERT INTO site_info (key_name, value)
VALUES 
('facebook', 'https://www.facebook.com/caprichito'),
('instagram', 'https://www.instagram.com/caprichito'),
('whatsapp', 'https://wa.me/123456789'),
('address', 'Av. Siempre Viva 742, Buenos Aires, Argentina'),
('phone', '+54 11 1234 5678'),
('email', 'contacto@caprichito.com');

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- ID del usuario que realizó el pedido
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pendiente', 'procesado', 'enviado', 'cancelado') DEFAULT 'pendiente',
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,        -- Relaciona el item con un pedido
    product_id INT NOT NULL,      -- Relaciona el item con un producto
    quantity INT NOT NULL,        -- Cantidad solicitada del producto
    unit_price DECIMAL(10,2),     -- Precio unitario al momento del pedido
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,            -- Usuario que realizó la acción
    action VARCHAR(255) NOT NULL,    -- Descripción de la acción
    table_name VARCHAR(50),          -- Tabla afectada (opcional)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE quotes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,          -- Usuario que solicitó la cotización
    quote_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pendiente', 'enviada', 'aceptada', 'rechazada') DEFAULT 'pendiente',
    total DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Relacionar productos con una cotización
CREATE TABLE quote_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    quote_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (quote_id) REFERENCES quotes(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);
