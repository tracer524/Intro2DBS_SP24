create database lab1;
use lab1;
create table Student(
	SNO varchar(20) primary key,
	SNAME varchar(10),
	Gender varchar(6),
	BIRTHDAY date,
	DEPART varchar(20)
);
alter table Teacher
add primary key(tno(100));
alter table course
add primary key(cno);
alter table score
add primary key(sno(100), cno);
select * from Student;
describe student;
select * from Teacher;
describe teacher;
select * from Course;
select * from Score;

-- 1
ALTER TABLE student
ADD COLUMN AGE INT;

-- 2
UPDATE Student
SET AGE = YEAR(CURDATE())-YEAR(BIRTHDAY);

-- 3
UPDATE Student
SET AGE = AGE + 2;
ALTER TABLE Student
MODIFY AGE CHAR(3);

-- 4
ALTER TABLE Student
DROP COLUMN AGE;

-- 5
CREATE TABLE teacher_course AS
SELECT TNO
FROM Teacher;
ALTER TABLE teacher_course
	ADD PRIMARY KEY (TNO(20)),
	ADD COLUMN NUM_COURSE INT;
select * from teacher_course
	
