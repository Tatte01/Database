SELECT 
    c.id,
    c.name,
    order_status(o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at) AS status,
    get_timestamp(order_status(o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at), o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at) AS status_time
FROM orders o
JOIN customer c ON o.customer_id = c.id;


order id, 
order datum,
kundens id, 
totalt antal orderrader den innehåller, 
dess status.

SELECT
    o.id AS order_id,
    c.id AS customer_id,
    c.name AS customer_name,
    get_timestamp(order_status(o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at),
    o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at) AS status_time,
    
    order_status(o.created_at, o.updated_at, o.deleted_at, o.ordered_at, o.shipped_at) AS status
FROM orders o
JOIN customer c ON o.customer_id = c.id;
