-- Alla tabler
-- Drop existing tables if they exist
DROP TABLE IF EXISTS ProductCategory;
DROP TABLE IF EXISTS logs;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS storage;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS customer;

-- Create customer table
CREATE TABLE customer (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(100) NOT NULL,
    phone VARCHAR(100) NOT NULL,
    number_of_orders INT,
    total_Spent DECIMAL(10,2) DEFAULT 0.00
);

-- Create indexes for customer table
CREATE INDEX idx_name ON customer(name);
CREATE INDEX idx_address ON customer(address);
CREATE INDEX idx_phone ON customer(phone);

-- Create product table
CREATE TABLE product (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- Create category table
CREATE TABLE category (
    namn CHAR(50) NOT NULL
);

-- Create storage table
CREATE TABLE storage (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    shelf_location TEXT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

-- Create orders table
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL,
    deleted_at DATETIME DEFAULT NULL,
    ordered_at DATETIME DEFAULT NULL,
    shipped_at DATETIME DEFAULT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE
);

-- Create logs table
CREATE TABLE logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    event_type VARCHAR(255) NOT NULL,
    description TEXT NOT NULL
);

-- Create ProductCategory table
CREATE TABLE ProductCategory (
    product_id INT,
    category_type CHAR(50),
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,
    FOREIGN KEY (category_type) REFERENCES category(namn) ON DELETE CASCADE,
    PRIMARY KEY (product_id, category_type)
);

-- If the table exists, drop it first
DROP TABLE IF EXISTS order_items;

-- Create the order_items table
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL, 
    product_id INT NOT NULL,  
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,  
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,  -- Link to orders table
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE -- Link to product table
);
