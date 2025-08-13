/**
 * This is were all the funcsions are stored
 */
"use strict";
//fucsion exports
module.exports = {
    showCategories: showCategories,
    showproducts: showproducts,
    createproduct : createproduct,
    showproduct : showproduct,
    editProduct : editProduct,
    deleteProduct : deleteProduct,
    showstorage : showstorage,
    inv_opsion : inv_opsion,
    inv_name_search : inv_name_search,
    invadd : invadd,
    show_logs_limit : show_logs_limit,
    invdel : invdel,
    show_customers : show_customers,
    show_customers_id : show_customers_id,
    order_page : order_page,
    createorder : createorder,
    addOrderItems : addOrderItems,
    getProductInventory : getProductInventory,
    getOrderdetails : getOrderdetails,
    orders_search : orders_search,
    picklist : picklist,
    shipped_order : shipped_order,
    linkcatoagorys: linkcatoagorys,
    one_product: one_product,
    picklist1st : picklist1st,
    allafakturor : allafakturor,
    onefaktura : onefaktura,
    paymentcli : paymentcli
}
// so i can use async
const mysql = require("promise-mysql");
//connect to database
const config = require("../config/db/eshop.json");
const { get } = require("../route/eshop");

let db;

/**
 * Connect function.
 * @async
 * @returns void
 */
(async function() {
    db = await mysql.createConnection(config);

    process.on("exit", () => {
        db.end();
    });
})();
/**
 * 
 * i keep the console.table commented out for test porpuses only.
 */
async function showCategories() {
    let sql = "CALL show_categorys";
    let res;

    res = await db.query(sql);
    //console.info(`printed ${sql} and got ress on the website`);
    //console.table(res[0]);
    return res[0];
}

async function showproducts() {
    let sql =  "CALL get_all_products();";
    let res;

    res = await db.query(sql);
    //console.info(`printed ${sql} and got ress on the website`);
    //console.table(res[0]);
    return res[0];
}

async function createproduct(id, name, price) {
    try {
        // Insert into Product
        let sqlProduct = "CALL insert_product(?, ?, ?)";
        await db.query(sqlProduct, [id, name, price]);
        
        //console.log("Product, Category, and Storage inserted successfully.");
    } catch (error) {
        console.error("Error inserting product:", error);
        throw error; // Rethrow the error or handle it
    }
}

async function linkcatoagorys(id, category) { 
    let sqladdcaegory = "CALL linkcategory(?,?)";
    await db.query(sqladdcaegory, [id, category]);
    
}

async function one_product(id) {
    let sql = "CALL one_product(?)";
    let res;

    res = await db.query(sql, [id]);

    console.table(res[0]);
    return res[0];
}

async function showproduct(id) {
    let sql = "CALL show_one_product(?)";
    let res;

    res = await db.query(sql, [id]);
    // If there are results, return the product and categories
    if (res[0].length > 0) {
        let product = res[0][0]; // Assuming the first row contains product info
        let categories = res[0].map(row => row.category_type); // Get all category types
        
        // Return the formatted product data
        return { ...product, categories: categories };

    }
    //console.info(`printed ${sql} and got ress on the website`);
    console.table(res[0]);
}

async function editProduct(id, name, price) {
    const sql = "CALL update_product(?, ?, ?);";

    const res = await db.query(sql, [id, name, price]);

    //console.log(`Update res for product with ID ${id}:`, res);

    if (res.affectedRows > 0) {
        console.log(`Product with ID ${id} was successfully updated.`);
    } else {
        console.log(`No product found with ID ${id}, or no changes made.`);
    }

}


async function deleteProduct(id) {
    let sql = "CALL delete_product(?);";

    const res = await db.query(sql, [id]);
    //console.info(`SQL: ${sql} got ${res.length} rows.`);

}

async function showstorage() {
    let sql = "CALL show_storage";

    const res = await db.query(sql);

    return res[0];
}

async function inv_opsion() {
    let sql = "CALL inv_opsion";

    const res = await db.query(sql);

    return res[0];
}

async function inv_name_search(name) {
    let sql = "CALL inv_name_search(?)";
    console.log(name, "func");
    const res = await db.query(sql, [name]);
    //console.table(res[0]);
    return res [0];
}

async function invadd(id, shelf_location, quantity) {
    const sql = "CALL show_one_product(?)";
    

    const res = await db.query(sql, [id]);

    if (res[0].length > 0) {
        console.log("Product exists with ID:", id);
        console.log("But the quantity was added");
    
        // Update the quantity in the storage table for the given product_id
        const addsql = "CALL update_storage_quantity(?, ?, ?);";
    
        // Execute the query with the quantity and the product_id
        await db.query(addsql, [id, quantity, shelf_location]);
    }
    else {
        let name = "new product";
        let category = "Hot";
        let price = 50;
        createproduct(id, name, price, category, quantity, shelf_location);

        const res = await db.query(sql, [id]);

        if (res[0].length > 0) {
            console.log ("Product did not exsist but");
            console.log(`Product was added with id "${id}", Shelf "${shelf_location}" and with a quantity of "${quantity}"`);
        }
    }

}

async function show_logs_limit(number) {
    const sql = "CALL logs_show_limit(?)";
    console.log(`Shows the latest ${number} Logs.`);

    const res = await db.query(sql, [number]);

    console.table(res[0]);
}


async function invdel(id, shelf_location, quantity) { 
    const newquantity = -quantity;

    const sql = "CALL update_storage_quantity(?, ?, ?)";


    const res = await db.query(sql, [id, newquantity,shelf_location]);

    if (res.affectedRows > 0) {
        console.log(`Successfully updated storage for product ${id} at shelf ${shelf_location}.`);
    } else {
        console.log(`No records were updated.
        Please check if the product and shelf location are correct.`);
    }


}

async function show_customers() {
    const sql = "CALL show_customers()";

    const res = await db.query(sql);

    //console.table(res[0]);

    return res[0];
}

async function show_customers_id(id) {
    const sql = "CALL show_customers_id(?)";

    const res = await db.query(sql, [id])

    //console.table(res[0]);

    return res[0];
}

async function order_page() {
    const sql = "CALL orders()";

    const res = await db.query(sql);

    //console.table(res[0]);


    return res[0];
}

async function createorder(customerId) {
    console.log(customerId, "in the create funcsion");
    let sql = `INSERT INTO orders (customer_id, ordered_at) VALUES (?, NOW())`;
    let res = await db.query(sql, [customerId]);

    //console.log("Helllo from the",res.insertId);

    return res.insertId;

}

async function addOrderItems(orderId,productId,quantity) {

    let sql = `INSERT INTO order_items (order_id, product_id, quantity) VALUES (?, ?, ?)`;
    console.log (`Iam dadding the product on orderid ${orderId}`);
    console.log (`I am adding youre ${productId} times ${quantity}`);
    let res = await db.query(sql, [orderId, productId, quantity]);

    console.log(res);
    
}



async function getProductInventory(productId) {
    // Query to fetch the shelf with the highest quantity for the given product ID
    const result = await db.query("SELECT shelf_location FROM storage WHERE product_id = ? ORDER BY quantity DESC LIMIT 1;", [productId]);

    if (!result || result.length === 0) {
        return null; // Return null if no shelves are found
    }

    return result[0].shelf_location; // Return the shelf_location of the highest inventory
}



async function getOrderdetails(id) {
    let sql = "CALL all_order_details(?)";

    let res = await db.query(sql, [id]);
    console.log("you aree here boi");
    console.log(id);
    console.table(res[0]);

    return res[0];
}

async function orders_search(id) {
    let sql = "CALL orders_search(?)";

    let res = await db.query(sql, [id]);
    //console.log(res)
    if (res.length === 0 || res[0].length === 0) {
        return "The id had no order or customer equivalent";
    }

    return res[0];
}

async function picklist(orderid) {
    let sql = `CALL picklist(?)`;
    //console.log(orderid, " : Is the order id the funcsion got")
    let res = await db.query(sql, [orderid]);

    console.table(res[0]);
    return res[0];
}

async function picklist1st(orderid) {
    let sql = `CALL picklist1st(?)`;
    console.log(orderid, " : Is the order id the funcsion got")
    let res = await db.query(sql, [orderid]);

    console.table(res[0]);
    return res[0];
}

async function shipped_order(orderid) {
    let sql = `CALL update_to_shipped(?)`;

    let res = await db.query(sql, [orderid]);
    if (res.affectedRows > 0) {
        console.log(`Order ${orderid} has been shipped` );
    }
    else {
        console.log("You might be trying to shipp an order that does not exsist");
        console.log(`The order numer ${orderid} does not have a order equivalent`);
    }    
}

async function allafakturor() {
    let sql = `CALL allafakturor()`;

    let res = await db.query(sql);

    return res[0];
}

async function onefaktura(id) {
    let sql = `CALL fakturalines(?)`;

    let res = await db.query(sql, [id]);

    return res[0];
}

async function paymentcli(id, date) {
    let sql = `CALL paymentcli(?,?)`;

    await db.query(sql, [id, date]);

    console.log(`Faktura Nr: ${id} Har Betalats : ${date}`)
}