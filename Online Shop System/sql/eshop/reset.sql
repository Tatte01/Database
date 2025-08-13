-- Create the database if it doesn't exist and switch to it
CREATE DATABASE IF NOT EXISTS eshop;
USE eshop;

-- Create the tables
-- Drop existing tables if they exist
DROP TABLE IF EXISTS productcategory;
DROP TABLE IF EXISTS logs;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS storage;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS faktura;
DROP TABLE IF EXISTS faktura_lines;

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

-- Create productCategory table
CREATE TABLE productcategory (
    product_id INT,
    category_type CHAR(50),
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,
    FOREIGN KEY (category_type) REFERENCES category(namn) ON DELETE CASCADE,
    PRIMARY KEY (product_id, category_type)
);

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

-- Create the faktura table

CREATE TABLE faktura (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    invoice_date DATETIME NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Not Paid',
    payment_date DATETIME NULL DEFAULT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);


-- Create the faktura_lines table
CREATE TABLE faktura_lines (
    invoice_id INT,
    line_number INT,
    product_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES faktura(invoice_id),
    PRIMARY KEY (invoice_id, line_number)
);
-- TODO remvoe foram key 

/*
*/
ALTER TABLE faktura_lines 
DROP FOREIGN KEY [faktura_lines_ibfk_2];

-- Load data from CSV files

-- Load data into Category table
LOAD DATA LOCAL INFILE '/home/tatte01/dbwebb-kruser/databas/me/kmom05/eshop1/sql/eshop/csv/catagory.csv'
INTO TABLE category
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(namn);

-- Load data into Customer table
LOAD DATA LOCAL INFILE  '/csv/custumer.csv'
INTO TABLE customer
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id,name, number_of_orders, total_Spent);

-- Load data into Product table
LOAD DATA LOCAL INFILE '/csv/product.csv'
INTO TABLE product
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id,name,price);

-- Load data into Storage table
LOAD DATA LOCAL INFILE '/csv/storage.csv'
INTO TABLE storage
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(product_id, quantity, shelf_location);

-- Load data into Storage table
LOAD DATA LOCAL INFILE './csv/productCatagory.csv'
INTO TABLE productCategory
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(product_id, category_type);

-- Creating triggers for logging INSERT and UPDATE events on the 'product' table

DELIMITER $$

DROP TRIGGER IF EXISTS log_product_insert $$  
DROP TRIGGER IF EXISTS log_product_update $$  
DROP TRIGGER IF EXISTS log_product_delete $$
DROP TRIGGER IF EXISTS generate_invoice_after_shipment $$
DROP TRIGGER IF EXISTS paidfaktura $$

-- Trigger for INSERT event on the 'product' table
CREATE TRIGGER log_product_insert
AFTER INSERT ON product
FOR EACH ROW
BEGIN
    INSERT INTO logs (event_type, description)
    VALUES ('INSERT', CONCAT('A new product was added with ID: ', new.id, ', Name: ', new.name, ', Price: ', new.price));
END $$

-- Trigger for UPDATE event on the 'product' table
CREATE TRIGGER log_product_update
AFTER UPDATE ON product
FOR EACH ROW
BEGIN
    INSERT INTO logs (event_type, description)
    VALUES ('UPDATE', CONCAT('Product with ID: ', old.id, ' was updated. Old Name: ', old.name, ' New Name: '
    , new.name, ', Old Price: ', old.price, ' New Price: ', new.price));
END $$

-- trigger for DELETE event on the 'product' table
CREATE TRIGGER log_product_delete
AFTER DELETE ON product
FOR EACH ROW
BEGIN
    INSERT INTO logs (event_type, description)
    VALUES ('DELETE', CONCAT('Product with ID: ', old.id, ' Name: ', old.name, ' And Price: ', old.price));
END $$

CREATE TRIGGER generate_invoice_after_shipment
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF NEW.shipped_at IS NOT NULL AND (OLD.shipped_at IS NULL OR OLD.shipped_at != NEW.shipped_at) THEN
        -- faktura
        INSERT INTO faktura (order_id, invoice_date, total_amount)
        VALUES (
            NEW.id,
            NOW(),
            (SELECT COALESCE(SUM(oi.quantity * p.price), 0)
            FROM order_items oi
            JOIN product p ON oi.product_id = p.id
            WHERE order_id = NEW.id)
        );

        SET @invoice_id = LAST_INSERT_ID();

        -- faktura_lines 
        INSERT INTO faktura_lines(
            invoice_id,
            line_number,
            product_id,
            product_name,
            quantity,
            unit_price,
            line_total
        )
        SELECT
            @invoice_id,
            ROW_NUMBER() OVER (),
            oi.product_id,
            p.name,
            oi.quantity,
            p.price,
            (oi.quantity * p.price)
        FROM
            order_items oi
        JOIN 
            product p ON oi.product_id = p.id
        WHERE
            oi.order_id = NEW.id;

        INSERT INTO logs (event_type, description)
        VALUES (
            'invoice_created',
            CONCAT('Generated invoice ', @invoice_id, ' for order ', NEW.id)
        );
    END IF;
END$$


DELIMITER $$

CREATE TRIGGER paidfaktura
BEFORE UPDATE ON faktura
FOR EACH ROW 
BEGIN 
    IF NEW.status = 'Paid' AND OLD.status != 'Paid' THEN
        -- SET NEW.payment_date = NOW();
        
        -- Log the payment
        INSERT INTO logs (event_type, description)
        VALUES('faktura betald',
        CONCAT('Faktura: ', NEW.invoice_id, ' was paid on ', DATE_FORMAT(NOW(), '%Y-%m-%d')));
    END IF;
END$$

DELIMITER ;


/*
Procedures
*/
--  Delete presedure
DELIMITER $$
CREATE PROCEDURE delete_product(IN product_id INT)
BEGIN
    DELETE FROM product WHERE id = product_id;
END $$
DELIMITER ;

-- Edit
DELIMITER $$ 
CREATE PROCEDURE update_product(IN p_id INT, IN p_name VARCHAR(255), IN p_price DECIMAL(10,2))
BEGIN 
    UPDATE product
    SET name = p_name, price = p_price
    WHERE id = p_id;
    END $$
    DELIMITER;

-- Create a new product
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_product $$
CREATE PROCEDURE insert_product(
    IN p_id INT, 
    IN p_name VARCHAR(255), 
    IN p_price DECIMAL(10,2)
)
BEGIN
    INSERT INTO product (id, name, price)
    VALUES (p_id, p_name, p_price);
END $$

DELIMITER ;

-- Link product and category

DELIMITER $$
DROP PROCEDURE IF EXISTS linkcategory $$
CREATE PROCEDURE linkcategory(
    IN p_id INT,
    IN c_category VARCHAR(255)
)
BEGIN
    INSERT INTO productcategory (product_id,category_type)
    VALUES (p_id, c_category);
END $$

DELIMITER ;

-- Make a new category
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_product_category $$ 
CREATE PROCEDURE insert_product_category(
    IN p_product_id INT, 
    IN p_category_type VARCHAR(255)
)
BEGIN
    INSERT INTO productcategory (product_id, category_type)
    VALUES (p_product_id, p_category_type);
END $$

DELIMITER ;

-- Make a new link with a product, category and storage spot.
DELIMITER $$

DROP PROCEDURE IF EXISTS insert_storage $$

CREATE PROCEDURE insert_storage(
    IN p_product_id INT, 
    IN p_quantity INT, 
    IN p_shelf_location VARCHAR(255)
)
BEGIN
    INSERT INTO storage (product_id, quantity, shelf_location)
    VALUES (p_product_id, p_quantity, p_shelf_location);
END $$

DELIMITER ;

-- Showing all the products on the Product tab
DELIMITER $$

DROP PROCEDURE IF EXISTS get_all_products $$

CREATE PROCEDURE get_all_products()
BEGIN
    SELECT
    p.id,
    p.name,
    p.price,
    COALESCE(s.total_quantity, 0) AS quantity, -- Summing up all shelf quantities
    COALESCE(GROUP_CONCAT(DISTINCT pc.category_type ORDER BY pc.category_type ASC), 'None') AS category -- If no category exists, show 'None'
    FROM product p
    LEFT JOIN (
        SELECT product_id, SUM(quantity) AS total_quantity -- Summing quantities for each product in storage
        FROM storage
        GROUP BY product_id
    ) s ON p.id = s.product_id
    LEFT JOIN productcategory pc ON p.id = pc.product_id -- Allows products without category info
    GROUP BY p.id, p.name, p.price;

END $$

DELIMITER ;

-- Showing just one product based on the id
DELIMITER $$

DROP PROCEDURE IF EXISTS one_product $$

CREATE PROCEDURE one_product(IN product_id INT)
BEGIN 
    SELECT 
        * 
    FROM product
    WHERE id = product_id;
END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS show_one_product $$

CREATE PROCEDURE show_one_product(IN product_id INT)
BEGIN 
    SELECT 
        p.*, pc.category_type
    FROM product p
    JOIN productcategory pc ON p.id = pc.product_id
    WHERE p.id = product_id;
END $$

DELIMITER ;

-- Show all Categorys

DELIMITER $$ 

CREATE PROCEDURE show_categorys()
BEGIN 
    SELECT
        *
    FROM category;
END $$

DELIMITER;

-- Show the storage spaces

DELIMITER $$ 

CREATE PROCEDURE show_storage()
BEGIN
    SELECT
        DISTINCT shelf_location
    FROM storage;
END $$

DELIMITER;

-- Show What products in the database with shelf ()

DELIMITER $$ 
DROP PROCEDURE IF EXISTS inv_opsion;
CREATE PROCEDURE inv_opsion()
BEGIN 
    SELECT
        p.id,
        p.name,
        COALESCE(s.shelf_location, 'Not Assigned') AS shelf_location,
        COALESCE(s.quantity, 0) AS quantity
    FROM product p 
    LEFT JOIN storage s ON p.id = s.product_id;
END $$

DELIMITER;


-- Show what name mathces 

DELIMITER $$

CREATE PROCEDURE inv_name_search(IN product_name VARCHAR(255))
BEGIN
    SELECT
        p.id,
        p.name,
        s.shelf_location
    FROM product p
    JOIN storage s ON p.id = s.product_id
    WHERE p.name = product_name;
END $$

DELIMITER ;

-- add something to storage 

DELIMITER $$

CREATE PROCEDURE update_storage_quantity(
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_shelf_loc TEXT 
)
BEGIN
    IF p_shelf_loc IS NOT NULL THEN
        -- Update only the specific shelf location
        UPDATE storage
        SET quantity = quantity + p_quantity
        WHERE product_id = p_product_id 
        AND shelf_location = p_shelf_loc;
    ELSE
        -- Update ALL storage entries for this product ID
        UPDATE storage
        SET quantity = quantity + p_quantity
        WHERE product_id = p_product_id;
    END IF;
END $$

DELIMITER ;

-- logs
DROP PROCEDURE IF EXISTS logs_show_limit;

DELIMITER $$

CREATE PROCEDURE logs_show_limit(IN numder INT)
BEGIN
    SELECT 
        id,
        DATE_FORMAT(timestamp, '%Y-%m-%d %H:%i:%s') AS formatted_timestamp,
        event_type,
        description
    FROM logs
    ORDER BY id DESC
    LIMIT numder;
END $$

DELIMITER ;



-- Show all the customers

DELIMITER $$ 

CREATE PROCEDURE show_customers()
BEGIN
    SELECT
        *
    FROM customer;
END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS orders;

CREATE PROCEDURE orders()
BEGIN
    SELECT 
        o.id AS order_id,
        c.id AS customer_id,
        c.name AS customer_name,
        DATE_FORMAT(
            get_timestamp(
                order_status(o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at),
                o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at
            ), 
            '%Y-%m-%d %H:%i:%s' ) AS status_time,
        order_status(o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at) AS status,
        COUNT(oi.id) AS order_items_count 
    FROM orders o
    JOIN customer c ON o.customer_id = c.id
    LEFT JOIN order_items oi ON o.id = oi.order_id 
    GROUP BY o.id, c.id  
    ORDER BY status_time DESC
    LIMIT 20;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS orders_search;

CREATE PROCEDURE orders_search(IN search INT)
BEGIN
    SELECT 
        o.id AS order_id,
        c.id AS customer_id,
        c.name AS customer_name,
        DATE_FORMAT(
            get_timestamp(
                order_status(o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at),
                o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at
            ), 
            '%Y-%m-%d %H:%i:%s' 
        ) AS status_time,
        order_status(o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at) AS status,
        COUNT(oi.id) AS order_items_count 
    FROM orders o
    JOIN customer c ON o.customer_id = c.id
    LEFT JOIN order_items oi ON o.id = oi.order_id 
    WHERE o.id = search OR c.id = search  
    GROUP BY o.id, c.id, c.name, status_time, status 
    ORDER BY status_time DESC 
    LIMIT 20;
END $$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE show_customers_id(
    in customer_id INT
)
BEGIN
SELECT
    id,
    name
FROM customer
WHERE id = customer_id;
END $$

DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS all_order_details;
CREATE PROCEDURE all_order_details(IN input_id INT)
BEGIN
    SELECT
        oi.order_id ,
        p.name,
        oi.product_id,
        oi.quantity
    FROM order_items oi
    JOIN product p ON oi.product_id = p.id

    WHERE oi.order_id = input_id;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS picklist $$ 

CREATE PROCEDURE picklist(IN orderid INT)
BEGIN
    SELECT
        oi.order_id,
        p.id,
        p.name,
        oi.quantity AS 'amount ordered',
        COALESCE(s.quantity, 0) AS inventory,
        s.shelf_location AS shelf,
        storage_availability(s.quantity, oi.quantity) as storage
    FROM order_items oi
    JOIN product p ON oi.product_id = p.id
    LEFT JOIN storage s ON oi.product_id = s.product_id
    WHERE oi.order_id = orderid;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS picklist1st $$ 

CREATE PROCEDURE picklist1st(IN orderid INT)
BEGIN
    SELECT
        oi.order_id,
        p.id,
        p.name,
        oi.quantity AS 'amount ordered',
        COALESCE(s.quantity, 0) AS inventory,
        s.shelf_location AS shelf,
        storage_availability(s.quantity, oi.quantity) as storage
    FROM order_items oi
    JOIN product p ON oi.product_id = p.id
    LEFT JOIN storage s ON oi.product_id = s.product_id
    WHERE oi.order_id = orderid
    AND s.quantity = (
        SELECT MAX(s2.quantity)
        FROM storage s2
        WHERE s2.product_id = s.product_id
    )
    GROUP BY p.id, oi.order_id, oi.quantity, p.name, s.shelf_location, s.quantity, storage_availability(s.quantity, oi.quantity);
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE update_to_shipped(IN orderid INT)
BEGIN
    UPDATE orders
    SET shipped_at = NOW()
    WHERE id = orderid;
END $$

DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS allafakturor $$

CREATE PROCEDURE allafakturor()
BEGIN
    SELECT
    invoice_id,
    order_id,
    DATE_FORMAT(invoice_date, '%Y-%m-%d %H:%i') AS invoice_date,
    total_amount,
    status,
    payment_date AS payment_date
    FROM faktura;
END $$

DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS fakturalines $$
CREATE PROCEDURE fakturalines(IN id INT)
BEGIN
    SELECT
    invoice_id,
    line_number,
    product_id,
    product_name,
    quantity,
    unit_price,
    line_total 
    FROM faktura_lines
    WHERE invoice_id = id;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS paymentcli $$

CREATE PROCEDURE paymentcli(
    IN p_invoice_id INT,
    IN p_payment_date VARCHAR(255)
)
BEGIN
    UPDATE faktura
    SET 
        payment_date = p_payment_date,
        status = 'Betald'
    WHERE invoice_id = p_invoice_id;
END $$

DELIMITER ;

--  Funcsion that shows the right info for my oders 

DELIMITER $$

CREATE FUNCTION order_status(
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    ordered_at DATETIME,
    shipped_at DATETIME
) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
    IF shipped_at IS NOT NULL THEN
        RETURN 'Skickad';
    ELSEIF ordered_at IS NOT NULL THEN
        RETURN 'Beställd';
    ELSEIF deleted_at IS NOT NULL THEN
        RETURN 'Raderad';
    ELSEIF updated_at IS NOT NULL THEN
        RETURN 'Uppdaterad';
    ELSE
        RETURN 'Skapad';
    END IF;
END $$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION get_timestamp(
    status VARCHAR(50),
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    ordered_at DATETIME,
    shipped_at DATETIME
)
RETURNS DATETIME
DETERMINISTIC
BEGIN
    IF status = 'Skickad' THEN
        RETURN shipped_at;
    ELSEIF status = 'Beställd' THEN
        RETURN ordered_at;
    ELSEIF status = 'Raderad' THEN
        RETURN deleted_at;
    ELSEIF status = 'Uppdaterad' THEN
        RETURN updated_at;
    ELSE
        RETURN created_at;
    END IF;
END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS storage_availability $$

CREATE FUNCTION storage_availability(quantity INT, orderd INT)
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
    DECLARE enough INT;
    SET enough = quantity - orderd;

    IF enough < 0 THEN 
        RETURN 'NOT-ENOUGH-ITEMS';
    ELSEIF quantity >= 1 THEN 
        RETURN 'IN-STOCK';
    ELSE 
        RETURN 'OUT-OF-STOCK';
    END IF;
END $$

DELIMITER ;

CREATE FUNCTION Shipp_order(order_id INT)
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
