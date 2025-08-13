/**
 * General routes.
 */
"use strict";


const express = require("express");
const router  = express.Router();
const bodyParser = require("body-parser");
const urlencodedParser = bodyParser.urlencoded({ extended: false });
const funcsions = require("../src/eshop-func");
const sitename   = "| Coffe Casu";

module.exports = router;


router.get("/index", (req, res) => {
    let data = {
        title: `index ${sitename}`
    };

    
    res.render("index", data);
});


router.get("/category", async (req, res) => {
    let data = {
        title: `Category ${sitename}`
    };

    data.res = await funcsions.showCategories();

    res.render("category", data);
});


router.get("/about", (req, res) => {
    let data = {
        title: `About ${sitename}`
    };

    res.render("about", data);
});

router.get("/product", async (req, res) => {
    let data = {
        title: `Product ${sitename}`
    };

    data.res = await funcsions.showproducts();
    res.render("product", data);
});

router.get("/create", async (req, res) => {
    let data = {
        title: `Create new Product ${sitename}`
    };
    res.render("create", data);
});

router.post("/create", urlencodedParser, async (req, res) => {
    await funcsions.createproduct(req.body.id, req.body.name,req.body.price);
    
    const categories = req.body.category.split(",").map(cat => cat.trim());
    //console.log("Hello" + req.body.category);

    for(const category of categories) {
        //console.log(category);
        await funcsions.linkcatoagorys(req.body.id, category);
    };
    
    res.redirect("product")
});

router.get("/edit/:id", async (req, res) => {
    let id = req.params.id;
    let data = {
        title: `Edit Product ${id} ${sitename}`,
        product: await funcsions.one_product(id)
    };

    res.render("edit", data);
});

router.post("/edit", urlencodedParser, async (req, res) => {

    await funcsions.editProduct(req.body.id, req.body.name, req.body.price);
    res.redirect(`/product`);
});


router.get("/delete/:id", async (req, res) => {
    let id = req.params.id;
    let data = {
        title: `Delete Product ${id} ${sitename}`,
        product: id
    };

    data.res = await funcsions.one_product(id);

    //console.log("Sending product data to page:", data.res);

    res.render("delete", data);
});



router.post("/delete", urlencodedParser, async (req, res) => {

    //console.log("Delete request received for ID:", req.body.id);

    await funcsions.deleteProduct(req.body.id);
    res.redirect(`/product`);
});


router.get("/product/:id", async (req, res) => {
    let id = req.params.id;
    let data = {
        title: `Delete Product ${id} ${sitename}`,
        product: id
    };

    data.res = await funcsions.showproduct(id);

    //console.log("Sending product data to page:", data.res);

    res.render("productone", { ...data, categories: data.res.categories });
});

router.get ("/customers", async (req, res) => {
    let data = {
        title: `Customers List ${sitename}`
    }

    data.res = await funcsions.show_customers();

    res.render("customerlist", data);
});


router.get("/createorder/:id", async (req, res) => {
    const customerId = req.params.id;
    
    let data = {
        title: `Create Order ${sitename}`,
        products: await funcsions.showproducts(),
        customer: await funcsions.show_customers_id(customerId) 
    };


    res.render("createorder", data);
});



router.get("/order", async (req, res) => {
    let data = {
        title: `List of Orders ${sitename}`,
        orders: await funcsions.order_page()
    };

    //console.table(data.orders);

    res.render("order", data);
});


router.post("/submit-order", urlencodedParser, async (req, res) => {
    let data = {
        title: `Order Complete ${sitename}`
    };

    console.log(req.body.customer_id, " in there submit post");
    const customerId = req.body.customer_id;
    const orderItems = [];

    // Collect order items
    for (const [key, value] of Object.entries(req.body)) {
        if (key.startsWith("product_")) {
            const productId = key.split("_")[1];
            const quantity = parseInt(value);

            if (quantity > 0) {
                orderItems.push({ productId, quantity });
            }
        }
    }

    // If no products were selected
    if (orderItems.length === 0) {
        return res.send("No products were selected");
    }

    // Create the order
    const orderId = await funcsions.createorder(customerId);
    console.log("This is what is in the order ID", orderId);

    // Add order items to the order
    for (const item of orderItems) {
        await funcsions.addOrderItems(orderId, item.productId, item.quantity);
    }

    
    res.render("ordercomplete", data);
});





router.get("/orderdetails/:id", async (req, res) => {
    const id = req.params.id;

    let data = {
        title: `Order Details ${sitename}`,
        
    };

    data.res =  await funcsions.getOrderdetails(id);
    
    res.render("orderdetails", data)
});


router.get("/inv", async (req, res) => {
    let data = {
        title: `Inventory ${sitename}`,
    };

    data.res =  await funcsions.inv_opsion();
    
    res.render("inventory", data)
});

router.get("/invadd", async (req, res) => {
    let data = {
        title: `Inventory ${sitename}`,
    };
    res.render("invadd", data)
});

router.get("/invadd/:id/:shelf", async (req, res) => {
    let { id, shelf } = req.params; // Extract from URL
    let data = {
        title: `Inventory ${sitename}`,
        productId: id,
        shelfLocation: shelf
    };
    res.render("invadd", data);
});


router.post("/invadd", urlencodedParser, async (req, res) => {
    await funcsions.invadd(req.body.id, req.body.shelf, req.body.amount);
    res.redirect("/inv");
});

router.get("/invdel/:id/:shelf", async (req, res) => {
    let { id, shelf } = req.params; // Extract from URL
    let data = {
        title: `Inventory ${sitename}`,
        productId: id,
        shelfLocation: shelf
    };
    res.render("invdel", data);
});

router.post("/invdel", urlencodedParser, async (req, res) => {
    await funcsions.invdel(req.body.id, req.body.shelf, req.body.amount);
    res.redirect("/inv");
});


router.get("/categoryadd/:id/", async (req, res) => {
    let id = req.params.id;
    let data = {
        title: `Add Category for Product ${sitename}`,
        productId: id
    };
    res.render("addcategory", data);
});


router.post("/addcategory", urlencodedParser, async (req, res) => {
    let id = req.body.id;
    
    // this line will "clean up the array"
    const categories = req.body.category.split(",").map(cat => cat.trim()).filter(cat => cat !== "");
    console.log("Categories to add: " + categories);

    for (const category of categories) {
        console.log(`Linking category: ${category}`);
        await funcsions.linkcatoagorys(id, category);
    }

    res.redirect("/product");
});

router.get("/picklist/:id/", urlencodedParser, async (req,res) => {
    let data = {
        title: `Picklist ${sitename}`,
    };
    data.res = await funcsions.picklist(req.params.id);

    res.render("picklist", data)
});

router.post("/shipped/:id", urlencodedParser, async (req, res) => {
    let orderid = req.params.id;
    console.log("Shipped order ID: ", orderid);

    let orderlist = await funcsions.picklist1st(orderid);

    // Print the orderlist for debugging
    console.table(orderlist);

    for (const items of orderlist) {
        if(items.inventory < items['amount ordered']) {console.log("damn")};
        await funcsions.invdel(items.id, items.shelf, items['amount ordered']);
        console.log(`ID ${items.id} is removed from ${items.shelf} in ${items['amount ordered']}`);
    }
    await funcsions.shipped_order(orderid);
    res.redirect("/order");
});

router.get("/faktura", async (req, res) => {
    let data = {
        title: `Faktura ${sitename}`
    };

    data.res = await funcsions.allafakturor();

    res.render("faktura", data)
});

router.get("/fakturalines/:id", urlencodedParser, async (req, res) => {
    let data = {
        title: `Faktura ${sitename}`
    };
    data.res = await funcsions.onefaktura(req.params.id);

    console.table(data.res);
    
    res.render("fakturalines", data)
})