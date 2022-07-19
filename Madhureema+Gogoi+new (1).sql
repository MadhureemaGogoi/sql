show databases;
use orders;
show tables;

-- •	7. Write a query to display carton id, (len*width*height) as carton_vol and identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, Assume all items of an order are packed into one single carton (box). 
SELECT oi.ORDER_ID,(p.len*p.width*p.height*oi.product_quantity) as order_vol, c.CARTON_ID, (c.LEN*c.HEIGHT*c.WIDTH) as carton_vol
FROM product p 
INNER join ORDER_ITEMS oi on oi.PRODUCT_ID = p.PRODUCT_ID 
LEFT join CARTON c on c.LEN = p.LEN
where oi.ORDER_ID = '10006'
and carton_vol > order_vol;

-- •	8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty) products per shipped order. (11 ROWS) 

SELECT oc.CUSTOMER_ID, oc.CUSTOMER_FNAME, oh.ORDER_ID, oh.ORDER_STATUS, sum(oi.PRODUCT_QUANTITY)
FROM ORDER_HEADER oh
LEFT JOIN ONLINE_CUSTOMER oc ON oc.CUSTOMER_ID = oh.CUSTOMER_ID
LEFT JOIN ORDER_ITEMS oi on oi.ORDER_ID = oh.ORDER_ID
GROUP by oh.CUSTOMER_ID
HAVING sum(oi.PRODUCT_QUANTITY) > 10
and oh.ORDER_STATUS = 'Shipped';

-- •	9.Write a query to display the order_id, customer id and cutomer full name of customers along with (product_quantity) as total quantity of products shipped for order ids > 10060. (6 ROWS) 

select oh.ORDER_ID, oc.CUSTOMER_ID, oc.CUSTOMER_FNAME, sum(oi.PRODUCT_QUANTITY) as Total_quantity, oh.ORDER_STATUS
from order_header oh
left join online_customer oc on oc.CUSTOMER_ID = oh.CUSTOMER_ID
inner join order_items oi on oi.ORDER_ID = oh.ORDER_ID
group by oh.ORDER_ID
having oh.ORDER_ID >10060
and oh.ORDER_STATUS = 'Shipped';

-- •	10. Write a query to display product class description,   total quantity (sum(product_quantity),Total value (product_quantity * product price) and show which class of products have been shipped highest(Quantity) to countries outside India other than USA? Also show the total value of those items. (1 ROWS)

SELECT pc.PRODUCT_CLASS_DESC, p.PRODUCT_ID, sum(oi.product_quantity) as total_quantity ,(oi.product_quantity * p.PRODUCT_PRICE) as Total_value
FROM PRODUCT p
inner JOIN ORDER_ITEMS oi on oi.PRODUCT_ID = p.PRODUCT_ID
INNER join PRODUCT_CLASS pc on pc.PRODUCT_CLASS_CODE = p.PRODUCT_CLASS_CODE
GROUP by oi.PRODUCT_QUANTITY
order by Total_value DESC LIMIT 1;

SELECT pc.PRODUCT_CLASS_DESC, p.PRODUCT_CLASS_CODE, oh.ORDER_STATUS, count(oi.product_quantity) as Total_product_quantity, a.COUNTRY
FROM PRODUCT_CLASS pc
inner JOIN PRODUCT p on p.PRODUCT_CLASS_CODE = pc.PRODUCT_CLASS_CODE
inner join ORDER_ITEMS oi on oi.PRODUCT_ID = p.PRODUCT_ID
inner join ORDER_HEADER oh on oh.ORDER_ID = oi.ORDER_ID
inner join ONLINE_CUSTOMER on ONLINE_CUSTOMER.CUSTOMER_ID = oh.CUSTOMER_ID
INNER join ADDRESS a on a.ADDRESS_ID = ONLINE_CUSTOMER.ADDRESS_ID
where a.COUNTRY is NOT 'India';

