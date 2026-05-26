-- ======================================================
-- 餐厅点餐管理系统 - 数据查询模块 (3.3)
-- 基于 homework.sql 中的表结构及测试数据编写
-- 包含五类查询：单表条件查询、多表连接查询、嵌套子查询、
--              分组统计查询、排序查询
-- ======================================================

-- 切换数据库
USE homework;

-- ------------------------------------------------------
-- 1. 带 WHERE 条件的单表查询
-- 功能：筛选在售且单价 > 10 元的菜品，按价格降序展示
-- ------------------------------------------------------
SELECT dish_id, dish_name, price, description
FROM dish
WHERE status = 1 AND price > 10
ORDER BY price DESC;


-- ------------------------------------------------------
-- 2. 多表连接查询
-- 功能：查询每个订单明细的完整信息（订单号、桌号、菜品名、数量、小计）
-- ------------------------------------------------------
SELECT 
    o.order_id,
    dt.table_no,
    d.dish_name,
    od.quantity,
    od.subtotal
FROM order_detail od
JOIN orders o ON od.order_id = o.order_id
JOIN dish d ON od.dish_id = d.dish_id
JOIN dining_table dt ON o.table_id = dt.table_id;


-- ------------------------------------------------------
-- 3. 嵌套子查询（IN 子查询）
-- 功能：查询至少点过一次“鱼香肉丝”（dish_id=1）的订单信息
-- ------------------------------------------------------
SELECT order_id, table_id, order_time, total_amount, status
FROM orders
WHERE order_id IN (
    SELECT DISTINCT order_id
    FROM order_detail
    WHERE dish_id = 1
);

-- 附加：相关子查询示例 - 查询每道菜被点的总份数（含菜名）
SELECT 
    d.dish_name,
    (SELECT SUM(od.quantity) 
     FROM order_detail od 
     WHERE od.dish_id = d.dish_id) AS total_quantity
FROM dish d;


-- ------------------------------------------------------
-- 4. 分组统计查询（GROUP BY + 聚合函数）
-- 功能：按订单分组，统计每个订单的菜品项数、总份数、总金额
-- ------------------------------------------------------
SELECT 
    order_id,
    COUNT(*) AS item_count,
    SUM(quantity) AS total_quantity,
    SUM(subtotal) AS calculated_total
FROM order_detail
GROUP BY order_id;


-- ------------------------------------------------------
-- 5. 排序查询（ORDER BY）
-- 功能：所有菜品按分类升序、价格降序排列
-- ------------------------------------------------------
SELECT dish_id, dish_name, category_id, price, status
FROM dish
ORDER BY category_id ASC, price DESC;