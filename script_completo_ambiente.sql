

-- Crear tabla productos
CREATE TABLE products (
    code VARCHAR PRIMARY KEY,
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR NOT NULL,
    price DECIMAL NOT NULL CHECK (price >= 0),
    brand VARCHAR
);

-- Crear tabla detalles de carrito
CREATE TABLE cart_details(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cart_id INTEGER NOT NULL,
    product_code VARCHAR NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (cart_id) REFERENCES cart(id) ON DELETE CASCADE,
    FOREIGN KEY (product_code) REFERENCES products(code) ON UPDATE CASCADE
);

-- Crear tabla detalles de factura
CREATE TABLE invoice_details (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice_number INTEGER NOT NULL,
    product_code VARCHAR NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL NOT NULL CHECK (subtotal >= 0),
    FOREIGN KEY (invoice_number) REFERENCES bills (invoice_number) ON DELETE CASCADE,
    FOREIGN KEY (product_code) REFERENCES products(code) ON UPDATE CASCADE
);

-- Crear tabla empleados
CREATE TABLE employees (
    code INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL
);

-- Crear tabla carrito
CREATE TABLE cart (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    buyer_email TEXT NOT NULL,
    created_at TEXT DEFAULT (datetime('now'))
);

-- Crear tabla facturas/bills
CREATE TABLE bills (
    invoice_number TEXT PRIMARY KEY,
    purchase_date DATETIME,
    buyer_email TEXT,
    amount DECIMAL CHECK (amount >= 0),
    phone TEXT,
    employee_code INTEGER,
    FOREIGN KEY (employee_code) REFERENCES employees(code) ON DELETE SET NULL
);

-- Insertar datos de ejemplo en products
INSERT INTO products VALUES('P001', 1, 'Producto A', 25000, 'Marca1');
INSERT INTO products VALUES('P002', 2, 'Producto B', 75000, 'Marca2');
INSERT INTO products VALUES('P003', 3, 'Producto C', 45000, 'Marca3');

-- Insertar datos de ejemplo en cart
INSERT INTO cart (buyer_email) VALUES('prueba@hotmail.com');
INSERT INTO cart (buyer_email) VALUES('usuario@gmail.com');

-- Insertar datos de ejemplo en cart_details
INSERT INTO cart_details VALUES(1, 1, 'P001', 2);
INSERT INTO cart_details VALUES(2, 1, 'P002', 1);
INSERT INTO cart_details VALUES(3, 2, 'P001', 3);

-- Insertar datos de ejemplo en bills
INSERT INTO bills VALUES('F001', '2023-08-01 10:30:00', 'prueba@hotmail.com', 125000, '555-1234', NULL);
INSERT INTO bills VALUES('F002', '2023-08-02 14:45:00', 'usuario@gmail.com', 75000, '555-5678', NULL);

-- ============================================
-- EJERCICIO EXTRA (extraexersecise.db)
-- ============================================

-- Crear tabla categorías
CREATE TABLE categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    description TEXT
);

-- Crear tabla productos (versión ejercicio extra)
CREATE TABLE products_extra (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code VARCHAR NOT NULL UNIQUE,
    product_name TEXT NOT NULL,
    price INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    category_id INTEGER REFERENCES categories(id)
);

-- Crear tabla facturas (versión ejercicio extra)
CREATE TABLE invoices (
    invoice_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer TEXT NOT NULL,
    total INTEGER NOT NULL CHECK(total >= 0),
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    phone TEXT,
    cashier_code TEXT NOT NULL DEFAULT 'N/A'
);

-- Insertar datos en categories
INSERT INTO categories VALUES(1,'Electronics','Phone, laptops, gadgets');
INSERT INTO categories VALUES(2,'Groceries','Food, beverage, daily goods');
INSERT INTO categories VALUES(3,'Accessories','Cases, chargers, add-ons');

-- Insertar datos en products_extra
INSERT INTO products_extra VALUES(1,'PE001','Apple iPhone Case',12000,15,3);
INSERT INTO products_extra VALUES(2,'PE002','USB-C Charger 30W',9100,8,3);
INSERT INTO products_extra VALUES(3,'PE003','Gaming Laptop',650100,2,1);
INSERT INTO products_extra VALUES(4,'PE004','4K Monitor 27"',220100,5,1);
INSERT INTO products_extra VALUES(5,'PE005','Green apple (1kg)',1800,40,2);
INSERT INTO products_extra VALUES(6,'PE006','Pineapple Juice 1L',1600,25,2);
INSERT INTO products_extra VALUES(7,'PE007','Bluetooth Headphones',45000,12,1);
INSERT INTO products_extra VALUES(8,'PE008','Smart TV 55"',380100,2,1);
INSERT INTO products_extra VALUES(9,'PE009','Mechanical Keyboard',52100,9,1);
INSERT INTO products_extra VALUES(10,'PE010','Phone Tripod',7000,30,3);

-- Insertar datos en invoices
INSERT INTO invoices VALUES(1,'Alice',120000,'2025-08-20 21:44:39','2479-1111','A01');
INSERT INTO invoices VALUES(2,'Bob',45000,'2025-08-20 21:44:39','2479-1111','A01');
INSERT INTO invoices VALUES(3,'Carol',78000,'2025-08-20 21:44:39','2479-1111','A01');
INSERT INTO invoices VALUES(4,'Dave',30000,'2025-08-20 21:44:39','8888-0000','B07');
INSERT INTO invoices VALUES(5,'Eve',155000,'2025-08-20 21:44:39','8888-0000','B07');

-- ============================================
-- CONSULTAS DE LOS EJERCICIOS
-- ============================================


-- Ver todos los productos
SELECT * FROM products;

-- Ver productos con precio mayor a 50000
SELECT * FROM products WHERE price > 50000;

-- Ver detalles de compras finalizadas para producto P001
SELECT * FROM invoice_details WHERE product_code = "P001";

-- Agrupar por código de producto y sumar cantidades de compras finalizadas
SELECT
    product_code,
    SUM(quantity) AS total_uni
FROM invoice_details
GROUP BY product_code;

-- Ver facturas de email específico
SELECT * FROM bills WHERE buyer_email = "prueba@hotmail.com";

-- Ver facturas ordenadas por monto descendente
SELECT * FROM bills ORDER BY amount DESC;

-- Ver factura específica
SELECT * FROM bills WHERE invoice_number = "F001";


PRAGMA table_info(invoices);

-- Ver facturas sin teléfono
SELECT * FROM invoices WHERE phone IS NULL OR phone = '';

-- Ver factura específica
SELECT * FROM invoices WHERE invoice_id = 5;

-- ============================================
-- EJERCICIO EXTRA PUNTO 4 - ACTUALIZACIÓN DE DATOS
-- ============================================

-- Actualizar precio de un producto específico
UPDATE products_extra
SET price = 13500
WHERE code = 'PE001';

-- Actualizar cantidad en stock de múltiples productos
UPDATE products_extra
SET quantity = quantity + 10
WHERE category_id = 1;

-- Actualizar información de cliente en factura
UPDATE invoices
SET phone = '2479-2222'
WHERE customer = 'Alice';

-- Actualizar categoría de productos
UPDATE products_extra
SET category_id = 2
WHERE code = 'PE005';

-- Actualizar precio con incremento porcentual
UPDATE products_extra
SET price = price * 1.15
WHERE category_id = 3;