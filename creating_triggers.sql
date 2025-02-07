-- SOURCE /home/as/Desktop/db_project/creating_queries.sql; SOURCE /home/as/Desktop/db_project/creating_functions.sql; SOURCE /home/as/Desktop/db_project/creating_triggers.sql;


DELIMITER //
CREATE TRIGGER update_order_total_price
AFTER INSERT ON Order_Product
FOR EACH ROW
BEGIN
    DECLARE total decimal(10,2);
    SET total = getOrderTotalPrice(NEW.order_id);
    UPDATE `Order` SET total_price = total where id = NEW.order_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_wallet_balance_update
BEFORE update on User
FOR EACH ROW
BEGIN
    DECLARE transaction_type ENUM('add','sub');
    DECLARE transaction_amount decimal(10,2);
    DECLARE transaction_status ENUM('pending','completed','failed') DEFAULT 'pending';
    if NEW.wallet_balance > OLD.wallet_balance then
        set transaction_type = 'add';
        set transaction_amount = NEW.wallet_balance - OLD.wallet_balance;
    ELSEIF NEW.wallet_balance < OLD.wallet_balance then
        set transaction_type = 'sub';
        set transaction_amount = OLD.wallet_balance - NEW.wallet_balance;
    else
        set transaction_type = 'add';
        set transaction_amount = 0.00;
    end if;


    if transaction_type = 'sub' then
        if NEW.wallet_balance < 0 then
           set transaction_status = 'failed';
        else
           set transaction_status = 'completed';
        end if;
    else
        if transaction_amount = 0.00 then
          set transaction_status = 'failed';
        else
           set transaction_status = 'completed';
        end if;
    end if;

    if transaction_status = 'failed' then
        set NEW.wallet_balance = OLD.wallet_balance;
    end if;
    
    INSERT INTO Wallet_Transaction (
        user_id,
        type,
        amount,
        balance_before,
        balance_after,
        status,
        made_at
    ) VALUES(
        OLD.id,
        transaction_type,
        transaction_amount,
        OLD.wallet_balance,
        NEW.wallet_balance,
        transaction_status,
        NOW()
    );
    
END //
DELIMITER ;
