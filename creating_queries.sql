-- SOURCE /home/as/Desktop/db_project/creating_queries.sql;
drop database if exists cafeteria;
create database cafeteria;

CREATE TABLE Room (
    id int AUTO_INCREMENT primary key,
    name VARCHAR(100) UNIQUE NOT NULL

);
CREATE TABLE Role (
    id INT AUTO_INCREMENT primary key,
    name VARCHAR(100) UNIQUE NOT NULL
);
CREATE table Prodile_Pic(
    id INT AUTO_INCREMENT primary key,
    url VARCHAR(255) not null,
    user_id int not null,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP not null
);

CREATE TABLE Category(
    id int AUTO_INCREMENT primary key,
    name VARCHAR(100) UNIQUE not null
);
CREATE table Product_Pic(
    id int AUTO_INCREMENT primary key,
    url VARCHAR(255) unique not null
);
CREATE TABLE User(
    id int AUTO_INCREMENT primary key,
    first_name VARCHAR(50) not null,
    last_name VARCHAR(50) not null ,
    username VARCHAR(50) unique not null,
    emaiil VARCHAR(255) unique not null,
    phone VARCHAR(11) unique not null,
    password VARCHAR(255) not null,
    room_id int not null,
    profile_pic_id int ,
    role_id int not null,
    wallet_balance decimal(10,2) DEFAULT 0.00  not null,
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP not null
);
CREATE TABLE Wallet_Transaction(
    id int AUTO_INCREMENT primary key,
    user_id int not null,
    type ENUM(0,1) not null, -- 0 add ,  1 sub
    amount decimal(10,2) not null,
    balance_before decimal(10,2) not null,
    balance_after decimal(10,2) not null,
    made_at DATETIME DEFAULT CURRENT_TIMESTAMP not null
);
CREATE table Product (
    id int AUTO_INCREMENT primary key,
    name VARCHAR(255) not null,
    price decimal(10,2) not null,
    product_pic_id int,
    category_id int not null,
    status BOOLEAN DEFAULT FALSE not null
);
CREATE TABLE Order (
    id int AUTO_INCREMENT primary key,
    user_id int not null,
    status ENUM('pending', 'completed', 'canceled') DEFAULT 'pending' not null,
    total_price decimal(10,2) not null,
    note VARCHAR(255),
    room_id int not null,
    created_at DATETIME CURRENT_TIMESTAMP not null
);
CREATE TABLE Order_Product(
    id int AUTO_INCREMENT primary key,
    order_id int not null,
    product_id int not null,
    quantity tinyint not null,
    price decimal(10,2) not null
);
CREATE TABLE Payment(
    id int AUTO_INCREMENT PRIMARY KEY,
    order_id int not null,
    amount decimal(10,2) not null,
    method ENUM('wallet','card','delivery') not null,
    status ENUM('pending','completed','failed') DEFAULT 'pending' not null,
    made_at DATETIME CURRENT_TIMESTAMP  not null
);