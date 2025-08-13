module.exports.product = `
    INSERT INTO Product (id, name, price)
    VALUES (?, ?, ?);
`;

module.exports.productCategory = `
    INSERT INTO ProductCategory (product_id, category_type)
    VALUES (?, ?);
`;

module.exports.storage = `
    INSERT INTO storage (product_id, quantity, shelf_location)
    VALUES (?, ?, ?);
`;
