-- 1
select s.s_name as student,
    avg(sc.score) as avg_score
from tbl_score sc
    join tbl_student s on s.s_id = sc.s_id
group by s.s_id;
-- 2
select s.s_name as student,
    c.c_name as course
from tbl_student s
    join tbl_course c
where not exists (
        select sc.s_id
        from tbl_score sc
        where sc.s_id = s.s_id
            and sc.c_id = c.c_id
    );
-- 3
select s.s_name as student,
    c.c_name as course,
    sc.score as score
from tbl_student s
    join (
        select s_id
        from tbl_score
        where score < 60
        group by s_id
        having count(s_id) >= 2
    ) t on s.s_id = t.s_id
    join tbl_score sc on s.s_id = sc.s_id
    join tbl_course c on sc.c_id = c.c_id
where sc.score < 60;
