module.exports = `
UPDATE product
SET name = ?, price = ?
WHERE id = ?;
`;
