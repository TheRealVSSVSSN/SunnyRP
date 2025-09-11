-- Vehicle shop SQL schema
-- Uses standard MySQL tables

CREATE TABLE IF NOT EXISTS vehicle_display (
    id INT AUTO_INCREMENT PRIMARY KEY,
    model VARCHAR(60) NOT NULL,
    baseprice INT NOT NULL DEFAULT 0,
    commission INT NOT NULL DEFAULT 15
);

CREATE TABLE IF NOT EXISTS characters_cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner VARCHAR(64) NOT NULL,
    cid INT NOT NULL,
    license_plate VARCHAR(12) NOT NULL,
    name VARCHAR(60) NOT NULL,
    model VARCHAR(60) NOT NULL,
    purchase_price INT NOT NULL,
    financed INT DEFAULT 0,
    payments_left INT DEFAULT 0,
    last_payment INT DEFAULT 0,
    vehicle_state VARCHAR(10) DEFAULT 'Out'
);
