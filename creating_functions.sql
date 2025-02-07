-- SOURCE /home/as/Desktop/db_project/creating_queries.sql; SOURCE /home/as/Desktop/db_project/creating_functions.sql;

DELIMITER //
create FUNCTION isUserIdExists(userId int) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE isFound BOOLEAN;
    SELECT COUNT(*) > 0 into isFound from User WHERE id = userId;
    RETURN isFound;
END //
DELIMITER ;

DELIMITER //
create FUNCTION isUserEmailExists(userEmail VARCHAR(255)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE isFound BOOLEAN;
    SELECT COUNT(*) > 0 into isFound from User WHERE email = userEmail;
    RETURN isFound;
END //
DELIMITER ;

DELIMITER //
create FUNCTION isUserNameExists(userName VARCHAR(50)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE isFound BOOLEAN;
    SELECT COUNT(*) > 0 into isFound from User WHERE username = userName;
    RETURN isFound;
END //
DELIMITER ;


DELIMITER //
create FUNCTION isPhoneExists(userPhone VARCHAR(11)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE isFound BOOLEAN;
    SELECT COUNT(*) > 0 into isFound from User WHERE phone = userPhone;
    RETURN isFound;
END //
DELIMITER ;

DELIMITER //
create FUNCTION isOrderIdExists(orderId int) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE isFound BOOLEAN;
    SELECT COUNT(*) > 0 into isFound from `Order` WHERE id = orderId;
    RETURN isFound;
END //
DELIMITER ;


DELIMITER //
create FUNCTION isProductAvailable(productId int) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE isFound BOOLEAN;
    SELECT COUNT(*) > 0 into isFound from Product WHERE id = productId and `status` = TRUE;
    RETURN isFound;
END //
DELIMITER ;

DELIMITER //
create FUNCTION isRoleExists(roleId int) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE isFound BOOLEAN;
    SELECT COUNT(*) > 0 into isFound from `Role` WHERE id = roleId;
    RETURN isFound;
END //
DELIMITER ;

DELIMITER //
create FUNCTION isRoomExists(roomId int) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE isFound BOOLEAN;
    SELECT COUNT(*) > 0 into isFound from Room WHERE id = roomId;
    RETURN isFound;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION getUserBalance(userId int) RETURNS decimal(10,2)
DETERMINISTIC
BEGIN
    DECLARE balance decimal(10,2);
    SELECT wallet_balance into balance from User where id=userId;
    RETURN balance;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION getOrderTotalPrice(orderId INT) RETURNS decimal(10,2)
DETERMINISTIC
BEGIN
    DECLARE total decimal(10,2);
    SELECT sum(price * quantity) into total from Order_Product where order_id = orderId;
    RETURN total;
END //

DELIMITER ;


    DELIMITER //
    CREATE FUNCTION getUserRole(userId int) RETURNS VARCHAR(100)
    DETERMINISTIC
    BEGIN
        DECLARE roleName VARCHAR(100);
        select Role.name into roleName from User,Role where User.role_id = Role.id;
        return roleName;
    END //
    DELIMITER ;

/*
DELIMITER //
CREATE FUNCTION createUser(
firstName VARCHAR(50),
lastName VARCHAR(50),
userName VARCHAR(50),
userEmail VARCHAR(100),
hashedPassword varchar(255),
roomId int
) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE roleId int;
    SET roleId = 0;
END //
DELIMITER ;
*/

DELIMITER //
create PROCEDURE addNewUser(
    IN fName varchar(50),
    IN lName varchar(50),
    IN roomId int,
    IN userName varchar(50),
    IN userEmail VARCHAR(100),
    IN userPhone varchar(11),
    IN hashedPassword varchar(255)
)
BEGIN
-- roleId = 1 => unverified member/customer
    DECLARE roleId int DEFAULT 1;
    if NOT isRoleExists(roleId) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error 1001: Website Roles not init yet.';
    end if;
    if NOT isRoomExists(roomId) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error 1002: Room not found yet.';
    end if;
    if isUserNameExists(userName) or isUserEmailExists(userEmail) or isPhoneExists(userPhone) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error 1003: username/email/phone is already registered with another user.';
    end if;

    
    INSERT INTO  User (
        first_name,
        last_name,
        username,
        email,
        phone,
        password,
        room_id,
        profile_pic_id,
        role_id
        ) VALUES(
         fName,
         lName,
         userName,
         userEmail,
         userPhone,
         hashedPassword,
         roomId,
         null,
         roleId
    );

END //
DELIMITER ;

DELIMITER //
create FUNCTION addUserBalance(userId int,amount decimal(10,2)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    if amount <= 0 then
        RETURN FALSE;
    end if;

    if isUserIdExists(userId) THEN
        UPDATE User SET wallet_balance = wallet_balance + amount where id = userId;
        RETURN TRUE;
    else
        return FALSE;
    end if;
END //
DELIMITER ;

DELIMITER //
create FUNCTION subUserBalance(userId int, amount decimal(10,2)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE cur_user_balance decimal(10,2) DEFAULT 0.00;
    if amount <= 0.00 then
        RETURN FALSE;
    end if;

    if isUserIdExists(userId) THEN
        select wallet_balance into cur_user_balance from User WHERE id = userId;
        if (cur_user_balance - amount) >= 0.00 then
            update User set wallet_balance = wallet_balance - amount where id = userId;
        else
            RETURN FALSE;
        end if;

    else
        RETURN FALSE;
    end if;
END //
DELIMITER ;