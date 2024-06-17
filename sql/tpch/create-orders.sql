CREATE TABLE orders (
    o_orderkey BIGINT,
    o_custkey BIGINT,
    o_orderstatus CHAR(1),
    o_totalprice DECIMAL,
    o_orderdate DATE,
    o_orderpriority CHAR(15),
    o_clerk CHAR(15),
    o_shippriority INT,
    o_comment VARCHAR(79),
    PRIMARY KEY(o_orderkey)
)
