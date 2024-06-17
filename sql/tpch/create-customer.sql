CREATE TABLE customer (
    c_custkey BIGINT,
    c_name VARCHAR(25),
    c_address VARCHAR(40),
    c_nationkey BIGINT,
    c_phone CHAR(15),
    c_acctbal DECIMAL,
    c_mktsegment CHAR(10),
    c_comment VARCHAR(117),
    PRIMARY KEY(c_custkey)
)
