CREATE TABLE lineitem (
    l_orderkey BIGINT,
    l_partkey BIGINT,
    l_suppkey BIGINT,
    l_linenumber INT,
    l_quantity DECIMAL,
    l_extendedprice DECIMAL,
    l_discount DECIMAL,
    l_tax DECIMAL,
    l_returnflag CHAR(1),
    l_linestatus CHAR(1),
    l_shipdate DATE,
    l_commitdate DATE,
    l_receiptdate DATE,
    l_shipinstruct CHAR(25),
    l_shipmode CHAR(10),
    l_comment VARCHAR(44),
    PRIMARY KEY(l_orderkey, l_linenumber)
)
