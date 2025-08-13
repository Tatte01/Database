/**
 * @author Malte Eriksson
 */

const mysql = require("promise-mysql");
const readline = require("readline");
const config = require("./config/db/eshop.json");
const { clear, Console } = require("console");
const eshop = require("./src/eshop-func");
let db;

(async function () {
    db = await mysql.createConnection(config);
    process.on("exit", () => {
        db.end();
    })
})

console.log(" Welcome to my eshop cafe Store");
console.log(" Type 'menu' for further opions")
const Choice = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

async function askMenu() {
    Choice.question("Choice: \n", async (Menuinput) => {
        if (Menuinput === "menu") {
            clear();
            console.log("    ===== Menu =====");
            console.log(" Inv"); // done
            console.log(" Shelf"); // done
            console.log(" Product"); // done
            console.log(" Inv <str>"); // done
            console.log(" Invadd <productid> <shelf> <number>"); //done
            console.log(" Invdel <productid> <shelf> <number>");
            console.log(" Log <number>");// done
            console.log(" order <search>"); // done
            console.log(" picklist <orderid>"); // done 
            console.log(" ship <orderid>"); // done
            console.log(" payed <invoiceid> <date>"); // done
            console.log(" About"); // done
        } 
        else if (Menuinput === "inv") {
            console.table(await eshop.inv_opsion());
        }
        else if (Menuinput === "shelf") {
            console.table(await eshop.showstorage());
        } 
        else if (Menuinput === "product") {
            console.table(await eshop.showproducts());
        }  
        else if (Menuinput.startsWith("inv ")) { // Handle "inv <str>"
            let searchStr = Menuinput.substring(4);
            console.log (searchStr)
            console.table(await eshop.inv_name_search(searchStr));
        }
        else if (Menuinput.startsWith("invadd ")) {
            const parts = Menuinput.split(" ");
            const id = parts[1];
            const shelf = parts[2];
            const number = parts[3];
            console.log("id ", id);
            console.log("shelf ", shelf);
            console.log("number ", number)
            await eshop.invadd(id, shelf, number);
        }
        else if (Menuinput.startsWith("invdel ")){
            const parts = Menuinput.split(" ");
            const id = parts[1];
            const shelf = parts[2];
            const number = parts[3];
            
            const result = await eshop.invdel(id,shelf,number);
        }
        else if (Menuinput.startsWith("log ")) {
            const parts = Menuinput.split(" ");
            const nr = parts [1];

            await eshop.show_logs_limit(nr);
        }
        else if (Menuinput.startsWith("order")) {
            const parts = Menuinput.split(" ");
            const id = parts[1];
            console.log(id);
            if (id === undefined) {
                res = await eshop.order_page(); 
                console.table(res);
            }
            else {
                res = await eshop.orders_search(id);
                console.table(res);
            }
        }
        else if (Menuinput.startsWith("picklist ")) {
            const parts = Menuinput.split(" ");
            const orderid = parts[1];

            await eshop.picklist(orderid);
        }
        else if (Menuinput.startsWith("ship ")) {
            const parts = Menuinput.split(" ");
            const id = parts[1];

            await eshop.shipped_order(id);

        }
        else if (Menuinput.startsWith("payed ")) {
            const parts = Menuinput.split(" ");
            const id = parts[1];
            const date = parts[2];

            await eshop.paymentcli(id, date);
        }
        else if (Menuinput === "about") {
            console.log(" The members of this 'Group' are:");
            console.log(" 1. Malte Eriksson");
        } 
        else if (Menuinput === "exit") {
            console.log(" Okay, goodbye :)");
            Choice.close();
            process.exit(0);
        } 
        else {
            console.log("You need to enter a valid choice.");
        }

        askMenu(); // Keep asking for input
    });
}

askMenu(); // Start menu loop
