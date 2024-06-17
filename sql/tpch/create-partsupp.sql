CREATE TABLE partsupp (
    ps_partkey BIGINT,
    ps_suppkey BIGINT,
    ps_availqty INT,
    ps_supplycost DECIMAL,
    ps_comment VARCHAR(199),
    PRIMARY KEY(ps_partkey, ps_suppkey)
)
