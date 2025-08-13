module.exports = `
SELECT 
    p.id,
    p.name,
    p.price,
    s.quantity
FROM product p
JOIN storage s ON p.id = s.product_id
;
`;