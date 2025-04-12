-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-02-2025 a las 23:42:49
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `prog_cap`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `branches`
--

CREATE TABLE `branches` (
  `branch_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `branchname` varchar(100) NOT NULL,
  `mail` varchar(200) DEFAULT NULL,
  `cuit` varchar(20) DEFAULT NULL,
  `store_name` varchar(255) DEFAULT NULL,
  `province` varchar(200) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `website` varchar(200) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carousel`
--

CREATE TABLE `carousel` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `image_url` text NOT NULL,
  `title` text NOT NULL,
  `subtitle` text NOT NULL,
  `active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `carousel`
--

INSERT INTO `carousel` (`id`, `image_url`, `title`, `subtitle`, `active`, `created_at`) VALUES
(1, 'img/carrusel-1.jpg', 'Bienvenidos a Caprichito', 'La mejor tienda mayorista para mascotas y cotillón', 0, '2025-01-02 00:32:03'),
(2, 'img/carrusel-2.jpg', 'Nuevos Productos', 'Descubre nuestras ofertas en juguetes y accesorios.', 0, '2025-01-02 00:32:03'),
(3, 'img/carrusel-3.jpg', 'Cotillón de Calidad', 'Artículos para tus fiestas y eventos especiales.', 0, '2025-01-02 00:32:03'),
(4, '../static/img/carousel-1.jpg', 'Bienvenidos a Caprichito', 'La mejor tienda mayorista para mascotas y cotillón', 1, '2025-01-02 00:32:03'),
(5, '../static/img/carousel-.jpg', 'Nuevos Productos', 'Descubre nuestras ofertas en juguetes y accesorios.', 0, '2025-01-02 00:32:03'),
(6, '../static/img/carousel-1.jpg', 'Cotillón de Calidad', 'Artículos para tus fiestas y eventos especiales.', 1, '2025-01-02 00:32:03'),
(7, '../static/img/carousel-1.jpg', 'Nuevos Productos', 'Descubre nuestras ofertas en juguetes y accesorios.', 1, '2025-01-02 00:32:03');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cart`
--

CREATE TABLE `cart` (
  `cart_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cart`
--

INSERT INTO `cart` (`cart_id`, `user_id`, `created_at`) VALUES
(1, 1, '2025-02-16 22:54:54'),
(2, 3, '2025-02-17 22:23:19');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cart_item`
--

CREATE TABLE `cart_item` (
  `cartItem_id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contacts`
--

CREATE TABLE `contacts` (
  `contact_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `logs`
--

CREATE TABLE `logs` (
  `log_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orders`
--

CREATE TABLE `orders` (
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` enum('Pendiente','Confirmada','Cancelada','') DEFAULT 'Pendiente',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `cart_id`, `total_price`, `status`, `created_at`) VALUES
(1, 1, 1, 199.31, 'Cancelada', '2025-02-16 22:56:16'),
(2, 1, 1, 95.87, 'Pendiente', '2025-02-17 11:42:20'),
(3, 3, 2, 18.94, 'Pendiente', '2025-02-17 22:28:43'),
(4, 3, 2, 5.98, 'Pendiente', '2025-02-17 22:37:45'),
(5, 3, 2, 247.30, 'Pendiente', '2025-02-17 22:38:26'),
(6, 3, 2, 8.99, 'Pendiente', '2025-02-17 22:41:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `order_item`
--

CREATE TABLE `order_item` (
  `orderItem_id` bigint(20) UNSIGNED NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `order_item`
--

INSERT INTO `order_item` (`orderItem_id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(1, 1, 3, 5, 104.95),
(2, 1, 2, 9, 49.41),
(3, 1, 4, 5, 44.95),
(4, 2, 2, 1, 5.49),
(5, 2, 1, 1, 10.99),
(6, 2, 8, 3, 5.97),
(7, 2, 4, 5, 44.95),
(8, 2, 7, 1, 2.49),
(9, 2, 10, 2, 25.98),
(10, 3, 4, 1, 8.99),
(11, 3, 8, 5, 9.95),
(12, 4, 8, 1, 1.99),
(13, 4, 6, 1, 3.99),
(14, 5, 10, 5, 64.95),
(15, 5, 5, 5, 127.45),
(16, 5, 8, 5, 9.95),
(17, 5, 4, 5, 44.95),
(18, 6, 4, 1, 8.99);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `products`
--

CREATE TABLE `products` (
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `category_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `status` varchar(255) DEFAULT 'available',
  `recommended` tinyint(1) DEFAULT 0,
  `promotion` tinyint(1) DEFAULT 0,
  `imageurl` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `products`
--

INSERT INTO `products` (`product_id`, `category_id`, `name`, `description`, `price`, `status`, `recommended`, `promotion`, `imageurl`, `created_at`) VALUES
(1, 1, 'Pelota de Caucho', 'Pelota resistente para perros', 10.99, 'available', 1, 1, 'img/menu-2.jpg', '2025-01-02 00:32:03'),
(2, 1, 'Hueso de Juguete', 'Hueso masticable para perros', 5.49, 'available', 1, 1, 'img/menu-2.jpg', '2025-01-02 00:32:03'),
(3, 1, 'Rascador para Gatos', 'Rascador vertical para gatos', 20.99, 'available', 1, 1, 'img/menu-2.jpg', '2025-01-02 00:32:03'),
(4, 1, 'Juguete con Sonido', 'Juguete con sonido para entretenimiento de mascotas', 8.99, 'available', 0, 0, 'img/menu-2.jpg', '2025-01-02 00:32:03'),
(5, 1, 'Cama Acolchada', 'Cama acolchada para mascotas pequeñas y medianas', 25.49, 'available', 0, 0, 'img/menu-2.jpg', '2025-01-02 00:32:03'),
(6, 2, 'Globo Metalizado', 'Globos metalizados con formas divertidas', 3.99, 'available', 0, 0, 'img/menu-1.jpg', '2025-01-02 00:32:03'),
(7, 2, 'Confeti en Bolsa', 'Bolsa grande de confeti de papel', 2.49, 'available', 0, 0, 'img/menu-2.jpg', '2025-01-02 00:32:03'),
(8, 2, 'Sombrero de Fiesta', 'Sombrero colorido para celebraciones', 1.99, 'available', 0, 0, 'img/menu-2.jpg', '2025-01-02 00:32:03'),
(9, 2, 'Guirnalda Decorativa', 'Guirnalda con luces LED para fiestas', 15.99, 'available', 0, 0, 'img/menu-2.jpg', '2025-01-02 00:32:03'),
(10, 2, 'Piñata Grande', 'Piñata en forma de estrella, ideal para fiestas infantiles', 12.99, 'available', 0, 0, 'img/menu-2.jpg', '2025-01-02 00:32:03');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `product_variations`
--

CREATE TABLE `product_variations` (
  `variation_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `variation_name` varchar(255) NOT NULL,
  `variation_value` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `product_variations`
--

INSERT INTO `product_variations` (`variation_id`, `product_id`, `variation_name`, `variation_value`) VALUES
(1, 1, 'Tamaño', 'Pequeño'),
(2, 2, 'Tamaño', 'Grande'),
(3, 1, 'Altura', '60 cm'),
(4, 2, 'Altura', '120 cm'),
(5, 1, 'Forma', 'Estrella'),
(6, 2, 'Forma', 'Corazón'),
(7, 1, 'Longitud', '5 metros'),
(8, 2, 'Longitud', '10 metros');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `site_info`
--

CREATE TABLE `site_info` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key_name` varchar(255) NOT NULL,
  `value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `site_info`
--

INSERT INTO `site_info` (`id`, `key_name`, `value`) VALUES
(1, 'facebook', 'https://www.facebook.com/caprichito'),
(2, 'instagram', 'https://www.instagram.com/pelotascaprichito/'),
(3, 'whatsapp', 'https://wa.me/123458888'),
(4, 'address', 'Necochea 2332 - Ramos Mejía, Buenos Aires, Argentina'),
(5, 'phone', '+54 11 4651-5279'),
(6, 'email', 'ventas@didifas.com.ar');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(255) NOT NULL,
  `mail` varchar(255) NOT NULL,
  `password` text NOT NULL,
  `cuit` varchar(20) NOT NULL,
  `store_name` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `website` text DEFAULT NULL,
  `role` varchar(50) DEFAULT 'user',
  `comprador` varchar(100) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `username`, `mail`, `password`, `cuit`, `store_name`, `province`, `city`, `phone`, `address`, `website`, `role`, `comprador`, `status`, `created_at`) VALUES
(1, '', 'caprichito@gmail.com', 'pbkdf2:sha256:1000000$F1WStcUUvHb42DVU$244457cae96c8444392275ca5a7236cb3590320e8fa415a96719ceff43604221', '20422804413', 'Caprichito', 'CABA', 'CABA', NULL, NULL, NULL, 'admin', NULL, 'active', '2025-02-16 22:47:50'),
(3, '', 'tienda1@gmail.com', 'pbkdf2:sha256:1000000$NFjI4Hy5Jv3fvoq3$97f4d70540e303d745cc6ae9a751bc1bacc2fe3301057360dd2627082f59cdf4', '22-33333333-4', 'Tienda 1', 'Buenos Aires', 'Buenos Aires', NULL, NULL, NULL, 'user', NULL, 'active', '2025-02-17 21:35:53');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `branches`
--
ALTER TABLE `branches`
  ADD PRIMARY KEY (`branch_id`);

--
-- Indices de la tabla `carousel`
--
ALTER TABLE `carousel`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indices de la tabla `cart_item`
--
ALTER TABLE `cart_item`
  ADD PRIMARY KEY (`cartItem_id`);

--
-- Indices de la tabla `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`contact_id`);

--
-- Indices de la tabla `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`log_id`);

--
-- Indices de la tabla `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indices de la tabla `order_item`
--
ALTER TABLE `order_item`
  ADD PRIMARY KEY (`orderItem_id`);

--
-- Indices de la tabla `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indices de la tabla `product_variations`
--
ALTER TABLE `product_variations`
  ADD PRIMARY KEY (`variation_id`);

--
-- Indices de la tabla `site_info`
--
ALTER TABLE `site_info`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `branches`
--
ALTER TABLE `branches`
  MODIFY `branch_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `carousel`
--
ALTER TABLE `carousel`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `cart_item`
--
ALTER TABLE `cart_item`
  MODIFY `cartItem_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT de la tabla `contacts`
--
ALTER TABLE `contacts`
  MODIFY `contact_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `logs`
--
ALTER TABLE `logs`
  MODIFY `log_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `order_item`
--
ALTER TABLE `order_item`
  MODIFY `orderItem_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `products`
--
ALTER TABLE `products`
  MODIFY `product_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `product_variations`
--
ALTER TABLE `product_variations`
  MODIFY `variation_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `site_info`
--
ALTER TABLE `site_info`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
