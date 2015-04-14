DELETE FROM OBJECT_CART.cart_object WHERE cart_id in (
select a.id from (
#select a.* from (
#select c.id as cart_id, co.cart_id as co_cart_id, co.id as co_obj_id from cart_object co,cart c where c.ID=co.CART_ID 
select c.id from cart_object co, cart c where c.ID=co.CART_ID 
and USER_ID like 'PUBLIC%' and name = 'cdeCart'
and c.last_write_date > UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 180 DAY))
) a
)

