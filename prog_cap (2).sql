-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-01-2025 a las 17:27:46
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
  `total_price` decimal(10,2) NOT NULL,
  `status` varchar(50) DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `imageUrl` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `products`
--

INSERT INTO `products` (`product_id`, `category_id`, `name`, `description`, `price`, `status`, `recommended`, `promotion`, `imageUrl`, `created_at`) VALUES
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
(2, 'instagram', 'https://www.instagram.com/caprichito'),
(3, 'whatsapp', 'https://wa.me/123458888'),
(4, 'address', 'Av. Siempre Viva 742, Buenos Aires, Argentina'),
(5, 'phone', '+54 11 2222 3333'),
(6, 'email', 'contacto@caprichito.com');

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
  `status` varchar(50) DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `username`, `mail`, `password`, `cuit`, `store_name`, `province`, `city`, `phone`, `address`, `website`, `role`, `status`, `created_at`) VALUES
(1, 'admin', 'admin@caprichito.com', '123456', '20-12345678-9', NULL, 'Buenos Aires', 'CABA', '+54 11 1234-5678', 'Av. Siempre Viva 742', 'https://www.caprichito.com', 'admin', 'active', '2025-01-02 00:32:03'),
(2, 'tienda1', 'tienda1@mail.com', 'password1', '30-87654321-0', NULL, 'Córdoba', 'Córdoba Capital', '+54 351 555-1234', 'Calle Falsa 123', NULL, 'user', 'active', '2025-01-02 00:32:03'),
(3, 'tienda2', 'tienda2@mail.com', 'password2', '27-11223344-5', NULL, 'Santa Fe', 'Rosario', '+54 341 678-5678', 'Bv. Oroño 456', 'https://www.tienda2.com', 'user', 'active', '2025-01-02 00:32:03'),
(4, 'tienda3', 'tienda3@mail.com', 'password3', '23-44556677-1', NULL, 'Mendoza', 'Mendoza Capital', '+54 261 123-9876', 'Av. San Martín', NULL, 'user', 'active', '2025-01-02 00:32:03'),
(5, 'tienda4', 'tienda4@mail.com', 'password4', '26-99887766-4', NULL, 'Buenos Aires', 'Mar del Plata', '+54 223 987-4567', 'Calle 100 N° 200', 'https://www.tienda4.com', 'user', 'active', '2025-01-02 00:32:03'),
(6, 'tienda5', 'tienda5@gmail.com', 'pbkdf2:sha256:1000000$Grwp0ZDHMtamaqWV$e2c5ed644fc37b8237544c3cfc10d8adb85e57bd96e86e9a794e92ed2ce86036', '12-12345678-1', NULL, NULL, NULL, NULL, NULL, NULL, 'user', 'active', '2025-01-02 00:32:03'),
(7, 'tienda6', 'tienda6@gmail.com', 'pbkdf2:sha256:1000000$WaFtWfrto8v9cjzT$69e1afe374b845e2072d3256b4720c26ab86ca20b0d3f3cfce79b495fc44db96', '99-12345678-9', NULL, NULL, NULL, NULL, NULL, NULL, 'user', 'active', '2025-01-02 00:32:03'),
(8, 'tienda7', 'tienda7@gmail.com', 'pbkdf2:sha256:1000000$YPCVsmZoSzWy1z7X$468935e3d391655024e7adf0d6b5997fbde54c548f8239f769556d6ed29b24db', '55-55555555-5', NULL, NULL, NULL, NULL, NULL, NULL, 'user', 'active', '2025-01-02 00:32:03'),
(9, 'tienda8', 'tienda8@gmail.com', 'pbkdf2:sha256:1000000$fOddwvmkDlKUzrbn$6e71013e5d266eb86b08132b2e943d8d243d3db9c77add0bc9459cd5ea9c3cbb', '22-33333333-4', NULL, NULL, NULL, NULL, NULL, NULL, 'user', 'active', '2025-01-02 00:32:03'),
(10, 'tienda9', 'tienda9@gmail.com', 'pbkdf2:sha256:1000000$atlcQX7UmEjSvDw6$ad67fdad722a12d0258c6d8c0d31f899806d3c22892f533f1e719a7bfdc0fbb0', '44-77777777-8', NULL, NULL, NULL, NULL, NULL, NULL, 'user', 'active', '2025-01-02 00:32:03'),
(11, 'tienda10', 'tienda10@gmail.com', 'pbkdf2:sha256:1000000$rP03OXZ3voqwxiiA$8ddc0f55bd49fd1cb8eaa88b7a4bd3869512ff8b560f4394bf5d039f706bc158', '20-42280441-3', NULL, 'Buenos Aires', 'Ezeiza', NULL, NULL, NULL, 'user', 'active', '2025-01-02 00:32:03'),
(12, 'tienda11', 'tienda11@gmail.com', 'pbkdf2:sha256:1000000$pwLT7knQXFYDktfk$222fd805d375525dff888a25a814c813ec7248dccea2550ea2f878838f4108d9', '55-55555555-6', NULL, NULL, NULL, NULL, NULL, NULL, 'user', 'active', '2025-01-02 00:32:03'),
(13, 'tienda12', 'tienda12@gmail.com', 'pbkdf2:sha256:1000000$dBiQKZIsWEITWmPp$15fa4dcf97d0b7a4980e05513efcb6b9de08a3f537dcfcf235eee97807ebf11b', '98-76543219-9', NULL, NULL, NULL, NULL, NULL, NULL, 'user', 'active', '2025-01-02 00:32:03'),
(14, 'tienda13', 'tienda13@gmail.com', 'pbkdf2:sha256:1000000$ig09pfO3gV9wLVMH$d3c2044dbcb66a995efb915c5a9471c530ecf3f2fe9197e85f9e12688129df09', '66-66666666-6', NULL, NULL, NULL, NULL, NULL, NULL, 'user', 'active', '2025-01-02 00:32:03'),
(15, 'tienda14', 'tienda14@gmail.com', 'pbkdf2:sha256:1000000$Nn4FT8eYfk7EwnyU$698469fb3043b3441ba8b8d647f08285d27380978498491dae70e6b1987b0e46', '20-42280441-2', NULL, NULL, NULL, NULL, NULL, NULL, 'user', 'active', '2025-01-02 00:32:03'),
(16, '', 'tienda15@gmail.com', 'pbkdf2:sha256:1000000$sg44MFSrdGP9LET1$4a2d86346210cd9c10131c45b1e89c56d5dc72176b5a8aef2aacf33c639c61fa', '88-88888888-7', 'Tienda 15', '', '', NULL, NULL, NULL, 'user', 'active', '2025-01-02 23:46:26'),
(17, '', 'tienda16@gmail.com', 'pbkdf2:sha256:1000000$hFuBfbURCn6KXQVj$6e40a98330bd46468b541d4dbfd921c745e890b8573c33ace0a3d480b67e5ac0', '15-25814725-9', 'Tienda 16', 'Buenos Aires', 'CABA', NULL, NULL, NULL, 'user', 'inactive', '2025-01-02 23:57:52'),
(18, '', 'tienda17@gmail.com', 'pbkdf2:sha256:1000000$GhOVCL9dPsYHJDPh$5e2dbc45624a2de75bec46c4aefef5e244f44f755179683387a72b9d7b3e9cf0', '15-25814725-3', 'Tienda 17', '', '', NULL, NULL, NULL, 'user', 'active', '2025-01-03 00:41:09'),
(19, '', 'tienda18@gmail.com', 'pbkdf2:sha256:1000000$bGF0fkT5AQh8ytaB$db78138e4b181f02ce2675c4d2db22121ece3c6290293724fb56e9a3f636f0cb', '98-12345678-2', 'Tienda 18', '', '', '116513205', NULL, NULL, 'user', 'active', '2025-01-03 00:49:28'),
(20, '', 'tienda19@gmail.com', 'pbkdf2:sha256:1000000$eXqomzs73t9CLTxP$fd5cae7ba48b95890425f7d4fea02ddd1f8dc676401cd71355da94942cc79336', '98-12345678-0', 'Tienda 19', '', '', NULL, NULL, NULL, 'user', 'inactive', '2025-01-03 00:50:19'),
(21, '', 'tienda20@gmail.com', 'pbkdf2:sha256:1000000$fTxmPuN31Nmb591k$b277bd9bb29bbf30a17e527d45e2a33d663a40eedddb0576deaf0379d0b65904', '98-12345678-7', 'Tienda 20', '', '', NULL, NULL, NULL, 'user', 'inactive', '2025-01-03 00:57:23'),
(22, '', 'tienda21@gmail.com', 'pbkdf2:sha256:1000000$ynlL0PZEA06jmJ6q$4dd14dfd24da675113fc1643a4e95fd52b515a8c0915dda5a29e00bc6c52f61d', '98-12345678-6', 'Tienda 21', 'La Pampa', 'Santa Rosa', NULL, NULL, NULL, 'user', 'inactive', '2025-01-03 01:11:42'),
(23, '', 'caprichito@gmail.com', 'pbkdf2:sha256:1000000$jPqyoe9E7YnFx6aa$44227b28ef35840c86c0e63072a2a96c54492dab0a4229b66a006432ec6b9468', '42-280441-3', 'Caprichito', 'Buenos Aires', 'CABA', '', '', '', 'admin', 'active', '2025-01-03 01:50:35');

--
-- Índices para tablas volcadas
--

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
-- AUTO_INCREMENT de la tabla `carousel`
--
ALTER TABLE `carousel`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cart_item`
--
ALTER TABLE `cart_item`
  MODIFY `cartItem_id` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `order_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `order_item`
--
ALTER TABLE `order_item`
  MODIFY `orderItem_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
