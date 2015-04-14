DELETE FROM OBJECT_CART.CART WHERE USER_ID like 'PUBLIC%' and name = 'cdeCart'
#select * FROM OBJECT_CART.CART WHERE USER_ID like 'PUBLIC%' and name = 'cdeCart'
and last_write_date > UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 180 DAY))

