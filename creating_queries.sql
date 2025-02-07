-- SOURCE /home/as/Desktop/db_project/creating_queries.sql;
drop database if exists cafeteria;
create database cafeteria;
use cafeteria;

CREATE TABLE Room (
    id int AUTO_INCREMENT primary key,
    name VARCHAR(100) UNIQUE NOT NULL

);
CREATE TABLE Role (
    id INT AUTO_INCREMENT primary key,
    name VARCHAR(100) UNIQUE NOT NULL
);
CREATE table Profile_Pic(
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
    room_id int,
    profile_pic_id int ,
    role_id int,
    wallet_balance decimal(10,2) DEFAULT 0.00  not null,
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP not null
);
CREATE TABLE Wallet_Transaction(
    id int AUTO_INCREMENT primary key,
    user_id int not null,
    type ENUM('add','sub') not null,
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

CREATE table `Order` (
    id int AUTO_INCREMENT primary key,
    user_id int,
    status ENUM('pending', 'completed', 'canceled') DEFAULT 'pending' not null,
    total_price decimal(10,2) not null,
    note VARCHAR(255),
    room_id int,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP not null
);

CREATE TABLE Order_Product(
    id int AUTO_INCREMENT primary key,
    order_id int not null,
    product_id int,
    quantity tinyint not null,
    price decimal(10,2) not null
);

CREATE TABLE Payment(
    id int AUTO_INCREMENT PRIMARY KEY,
    order_id int,
    amount decimal(10,2) not null,
    method ENUM('wallet','card','delivery') not null,
    status ENUM('pending','completed','failed') DEFAULT 'pending' not null,
    made_at DATETIME DEFAULT CURRENT_TIMESTAMP not null
);

-- Adding The Foreign Keys
-- user's fks
ALTER TABLE User add CONSTRAINT fk_user_room_id
FOREIGN KEY (room_id) REFERENCES Room(id)
on DELETE set null;

ALTER TABLE User add CONSTRAINT fk_user_profile_pic_id
FOREIGN key (profile_pic_id) REFERENCES Profile_Pic(id)
on DELETE set null;

ALTER TABLE User add CONSTRAINT fk_user_role_id
FOREIGN KEY (role_id) REFERENCES Role(id)
on DELETE set null;

-- profile_pic's fks
ALTER TABLE Profile_Pic add CONSTRAINT fk_profile_pic_user_id
FOREIGN KEY (user_id) REFERENCES User(id)
on DELETE CASCADE;

-- wallet_transaction's fks
alter TABLE Wallet_Transaction add CONSTRAINT fk_wallet_transaction_user_id
FOREIGN KEY (user_id) REFERENCES User(id)
on DELETE CASCADE;

-- order's fks
alter table `Order` add CONSTRAINT fk_order_user_id
FOREIGN key (user_id) REFERENCES User(id)
on DELETE set null;

ALTER TABLE `Order` add CONSTRAINT fk_order_room_id
FOREIGN key (room_id) REFERENCES Room(id)
on DELETE set null;

-- product's fks
ALTER TABLE Product add CONSTRAINT fk_product_product_pic_id
FOREIGN KEY (product_pic_id) REFERENCES Product_Pic(id)
on DELETE set null;

ALTER TABLE Product add CONSTRAINT fk_product_category_id
FOREIGN key (category_id) REFERENCES Category(id)
on DELETE CASCADE;

-- order_product's fks
ALTER table Order_Product add CONSTRAINT fk_order_product_order_id
FOREIGN KEY (order_id) REFERENCES `Order`(id)
on DELETE CASCADE;

ALTER TABLE Order_Product add CONSTRAINT fk_order_product_product_id
FOREIGN KEY (product_id) REFERENCES Product(id)
on DELETE set null;

-- payment's fks
ALTER table Payment add CONSTRAINT fk_payment_order_id
FOREIGN KEY (order_id) REFERENCES `Order`(id)
on DELETE set null;
