CREATE TABLE supplier (
    s_suppkey BIGINT,
    s_name CHAR(25),
    s_address VARCHAR(40),
    s_nationkey BIGINT,
    s_phone CHAR(15),
    s_acctbal DECIMAL,
    s_comment VARCHAR(101),
    PRIMARY KEY(s_suppkey)
)
