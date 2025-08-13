-- kunder, produkter, produktkategorier, lagerhyllor

-- Load data from CSV files

-- Load data into Category table
LOAD DATA INFILE './csv/category.csv'
INTO TABLE category
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(namn);

-- Load data into Customer table
LOAD DATA INFILE './csv/customer.csv'
INTO TABLE customer
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id,name, address, phone);

-- Load data into Product table
LOAD DATA INFILE './csv/product.csv'
INTO TABLE product
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(name, price);

-- Load data into Storage table
LOAD DATA INFILE './csv/storage.csv'
INTO TABLE storage
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(product_id, quantity, shelf_location);