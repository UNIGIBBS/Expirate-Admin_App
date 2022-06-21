const express = require("express");
const mysql = require("mysql2/promise");

let db = null;
const app = express();


app.use(express.json);

async function main(){
    db = await mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "",
        database: "comp_part1_2",
        timezone: "+00:00",
        charset: "utf8mb4_general_ci",

    })
}

main();

