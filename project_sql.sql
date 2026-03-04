create database food_delivery;
use food_delivery;
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    rating DECIMAL(2,1) CHECK (rating BETWEEN 1 AND 5),
    is_active BOOLEAN DEFAULT TRUE
);
CREATE TABLE menu_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT,
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    restaurant_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    order_status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    item_id INT,
    quantity INT CHECK (quantity > 0),
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
CREATE TABLE delivery_partners (
    partner_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    phone VARCHAR(15),
    vehicle_number VARCHAR(20),
    is_available BOOLEAN DEFAULT TRUE
);
CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    partner_id INT,
    delivery_status VARCHAR(50),
    delivered_at DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (partner_id) REFERENCES delivery_partners(partner_id)
);

INSERT INTO users (name,email,phone,address) VALUES
('Arun','arun@gmail.com','9876543210','Chennai'),
('Karthik','karthik@gmail.com','9876543211','Chennai'),
('Priya','priya@gmail.com','9876543212','Bangalore'),
('Divya','divya@gmail.com','9876543213','Hyderabad'),
('Vijay','vijay@gmail.com','9876543214','Chennai'),
('Sneha','sneha@gmail.com','9876543215','Mumbai'),
('Rahul','rahul@gmail.com','9876543216','Delhi'),
('Anitha','anitha@gmail.com','9876543217','Chennai'),
('Manoj','manoj@gmail.com','9876543218','Pune'),
('Deepak','deepak@gmail.com','9876543219','Coimbatore');

INSERT INTO restaurants (name,location,rating) VALUES
('Spicy Hub','Chennai',4.5),
('Food Palace','Bangalore',4.2),
('Biryani House','Hyderabad',4.8),
('Pizza Corner','Mumbai',4.1),
('South Express','Chennai',4.3);

INSERT INTO menu_items (restaurant_id,item_name,category,price) VALUES
(1,'Chicken Biryani','Main Course',250),
(1,'Mutton Biryani','Main Course',320),
(1,'Grill Chicken','Starter',280),

(2,'Veg Meals','Main Course',180),
(2,'Paneer Butter Masala','Main Course',220),
(2,'Gobi Manchurian','Starter',150),

(3,'Hyderabadi Biryani','Main Course',300),
(3,'Double Ka Meetha','Dessert',120),
(3,'Chicken 65','Starter',200),

(4,'Margherita Pizza','Main Course',350),
(4,'Farmhouse Pizza','Main Course',420),
(4,'Garlic Bread','Starter',150),

(5,'Idli','Breakfast',50),
(5,'Dosa','Breakfast',80),
(5,'Meals Combo','Main Course',200);

INSERT INTO orders (user_id,restaurant_id,total_amount,order_status) VALUES
(1,1,250,'Delivered'),
(2,3,300,'Delivered'),
(3,2,180,'Pending'),
(4,4,350,'Delivered'),
(5,1,320,'Cancelled'),
(6,5,200,'Delivered'),
(7,3,500,'Delivered'),
(8,2,220,'Delivered'),
(9,4,420,'Pending'),
(10,5,80,'Delivered'),
(1,3,300,'Delivered'),
(2,1,280,'Delivered'),
(3,5,200,'Delivered'),
(4,2,150,'Delivered'),
(5,4,350,'Delivered');

INSERT INTO order_items (order_id,item_id,quantity,price) VALUES
(1,1,1,250),
(2,7,1,300),
(3,4,1,180),
(4,10,1,350),
(5,2,1,320),
(6,15,1,200),
(7,7,1,300),
(7,9,1,200),
(8,5,1,220),
(9,11,1,420),
(10,14,1,80),
(11,7,1,300),
(12,3,1,280),
(13,15,1,200),
(14,6,1,150),
(15,10,1,350);

INSERT INTO payments (order_id, payment_method, payment_status, payment_date) VALUES
(1,'UPI','Success','2026-02-01 12:30:00'),
(2,'Credit Card','Success','2026-02-02 13:00:00'),
(3,'Cash','Pending','2026-02-02 14:10:00'),
(4,'Debit Card','Success','2026-02-03 18:45:00'),
(5,'UPI','Failed','2026-02-03 19:00:00'),
(6,'Cash','Success','2026-02-04 09:30:00'),
(7,'Credit Card','Success','2026-02-05 20:15:00'),
(8,'UPI','Success','2026-02-06 11:40:00'),
(9,'Debit Card','Pending','2026-02-06 21:00:00'),
(10,'Cash','Success','2026-02-07 08:20:00'),
(11,'UPI','Success','2026-02-07 14:10:00'),
(12,'Credit Card','Success','2026-02-08 16:45:00'),
(13,'Debit Card','Success','2026-02-09 10:00:00'),
(14,'UPI','Success','2026-02-09 19:20:00'),
(15,'Credit Card','Success','2026-02-10 12:15:00');

INSERT INTO delivery_partners (name, phone, vehicle_number, is_available) VALUES
('Ravi Kumar','9000011111','TN09AB1234',TRUE),
('Suresh Babu','9000011112','TN10CD5678',TRUE),
('Ajith Kumar','9000011113','KA01EF2345',FALSE),
('Prakash','9000011114','MH12GH7890',TRUE),
('Dinesh','9000011115','TS09JK4567',TRUE),
('Vignesh','9000011116','TN07LM1111',FALSE),
('Aravind','9000011117','TN22NO2222',TRUE),
('Manikandan','9000011118','KA05PQ3333',TRUE),
('Ramesh','9000011119','DL08RS4444',TRUE),
('Santhosh','9000011120','TN14TU5555',FALSE),
('Kiran','9000011121','MH02UV6666',TRUE),
('Lokesh','9000011122','TN18WX7777',TRUE),
('Bharath','9000011123','KA09YZ8888',FALSE),
('Gokul','9000011124','TN01AA9999',TRUE),
('Saravanan','9000011125','TN11BB1010',TRUE);

INSERT INTO deliveries (order_id, partner_id, delivery_status, delivered_at) VALUES
(1,1,'Delivered','2026-02-01 13:05:00'),
(2,2,'Delivered','2026-02-02 13:35:00'),
(3,3,'Cancelled',NULL),
(4,4,'Delivered','2026-02-03 19:25:00'),
(5,5,'Cancelled',NULL),
(6,6,'Delivered','2026-02-04 09:55:00'),
(7,7,'Delivered','2026-02-05 20:55:00'),
(8,8,'Delivered','2026-02-06 12:20:00'),
(9,9,'Out for Delivery',NULL),
(10,10,'Delivered','2026-02-07 08:50:00'),
(11,11,'Delivered','2026-02-07 14:55:00'),
(12,12,'Out for Delivery',NULL),
(13,13,'Delivered','2026-02-09 10:45:00'),
(14,14,'Delivered','2026-02-09 19:45:00'),
(15,15,'Assigned',NULL);