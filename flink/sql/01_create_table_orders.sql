
-- `big-data-study/flink/reference/flink-sql-cookbook/foundations/01_create_table/01_create_table.md:34`


CREATE TABLE orders (
    order_uid  BIGINT,
    product_id BIGINT,
    price      DECIMAL(32, 2),
    order_time TIMESTAMP(3)
) WITH (
    'connector' = 'datagen',
    'rows-per-second'='5',
    'fields.order_uid.kind'='sequence',
    'fields.order_uid.start'='1',
    'fields.order_uid.end'='100',
    'fields.product_id.min'='1',
    'fields.product_id.max'='1000',
    'fields.price.min'='1.00',
    'fields.price.max'='1000.00'
);

-- 限制只查询前10条数据
SELECT * FROM orders LIMIT 10;

