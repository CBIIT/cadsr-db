DELETE FROM OBJECT_CART.CART WHERE USER_ID like 'PUBLIC%' and name = 'cdeCart'
#select * FROM OBJECT_CART.CART WHERE USER_ID like 'PUBLIC%' and name = 'cdeCart'
and last_write_date < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 10 DAY);

