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
describe course;
select * from Score;
describe score;

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
select * from teacher_course;
	
-- 6
UPDATE teacher_course tc
LEFT JOIN (
    SELECT TNO, COUNT(*) as num_courses
    FROM course
    GROUP BY TNO
) c ON tc.TNO = c.TNO
SET tc.NUM_COURSE = c.num_courses;

-- 7.
DELETE FROM teacher_course
WHERE NUM_COURSE IS NULL;

-- 8.
DROP TABLE teacher_course;

-- 9.
INSERT INTO Student(SNO, SNAME, Gender, BIRTHDAY, DEPART)
VALUES	('PB22151743', 'CSQ', 'male', '2005-02-04', '229'),
		('PB22114514', 'ABC', 'male', '2004-08-10', '15'),
		('PB21919810', 'DEF', 'female', '2004-03-16', '11');
INSERT INTO Score(SNO, CNO, DEGREE)
VALUES	('PB22151743', 20230402, 98),
		('PB22151743', 20230410, 99),
		('PB22151743', 20230412, 97);
        
-- 10.
DELETE s FROM score s
JOIN (
    SELECT MIN(DEGREE) as min_degree
    FROM score
    WHERE SNO = 'PB22151743'
) as t
ON s.DEGREE = t.min_degree
WHERE s.SNO = 'PB22151743';

-- 11.
CREATE INDEX NAME_INDEX ON Course(NAME(20));
SHOW INDEX FROM COURSE;

-- 12.
CREATE UNIQUE INDEX TNO_INDEX ON Teacher(TNO(10));
SHOW INDEX FROM TEACHER;

-- 13.
CREATE INDEX RECORD_INDEX ON Score (SNO(20) DESC, DEGREE ASC);

-- 14.
SHOW INDEX FROM score;

-- 15.
ALTER TABLE Teacher DROP INDEX TNO_INDEX;

-- 16.
SELECT SNO, SNAME
FROM Student
WHERE DEPART = (
    SELECT DEPART
    FROM Student
    WHERE SNO = 'PB22151743'
);

-- 17.
SELECT SNO, SNAME
FROM Student
WHERE DEPART = (
    SELECT DEPART
    FROM Student
    WHERE SNO = 'PB22151743'
) AND SNO != 'PB22151743';

-- 18.
SELECT SNO, SNAME
FROM Student
WHERE DEPART = (
    SELECT DEPART
    FROM Student
    WHERE SNO = 'PB22114514'
);

-- 19.
SELECT SNO, SNAME
FROM Student
WHERE DEPART NOT IN (
    SELECT DEPART
    FROM Student
    WHERE SNO IN ('PB22114514', 'PB21919810')
);

ALTER TABLE Teacher
CHANGE COLUMN NAME TNAME VARCHAR(20);

-- 20.
SELECT TNO, TNAME
FROM Teacher
WHERE TNO IN(
	SELECT TNO
    FROM Course
    WHERE CNO IN(
		SELECT CNO
        FROM Score
        WHERE SNO = ("PB22151743")
	)
);

-- 21.
SELECT COUNT(*)
FROM Teacher
WHERE DEPART IN ('11', '229');

-- 22.
SELECT SNO, SNAME, YEAR(CURDATE()) - YEAR(BIRTHDAY) AS Age
FROM Student
WHERE DEPART = (
    SELECT DEPART
    FROM Student
    WHERE SNO = 'PB22151743'
);

-- 23. 
SELECT SNO, SNAME, YEAR(CURDATE()) - YEAR(BIRTHDAY) AS Age
FROM Student
WHERE DEPART = (
    SELECT DEPART
    FROM Student
    WHERE SNO = 'PB22151743'
)
ORDER BY Age ASC
LIMIT 1;
		
-- 24.
SELECT s.SNO, s.SNAME, sc.DEGREE
FROM Student s
JOIN score sc ON s.SNO = sc.SNO
JOIN Course c ON sc.CNO = c.CNO
WHERE c.NAME = 'DB_Design' AND sc.DEGREE < 75;

-- 25.
SELECT DISTINCT s.SNO, s.SNAME
FROM Student s
JOIN score sc ON s.SNO = sc.SNO
JOIN Course c ON sc.CNO = c.CNO
JOIN Teacher t ON c.TNO = t.TNO
WHERE t.TNAME = 'ZDH';

-- 26.
SELECT sc.SNO, sc.DEGREE
FROM score sc
JOIN Course c ON sc.CNO = c.CNO
WHERE c.NAME = 'Machine_Learning'
ORDER BY sc.DEGREE DESC;

-- 27.
SELECT c.CNO, c.NAME, AVG(sc.DEGREE) AS Average_Score
FROM Course c
LEFT JOIN score sc ON c.CNO = sc.CNO
GROUP BY c.CNO, c.NAME;

-- 28.
SELECT c.CNO, c.NAME, AVG(sc.DEGREE) AS Average_Score
FROM Course c
LEFT JOIN score sc ON c.CNO = sc.CNO
WHERE c.TYPE = 1
GROUP BY c.CNO, c.NAME;

-- 29.
SELECT s.SNO
FROM Student s
JOIN score sc ON s.SNO = sc.SNO
JOIN Course c ON sc.CNO = c.CNO
WHERE c.TNO = 'TA90023'
GROUP BY s.SNO
HAVING COUNT(DISTINCT c.CNO) = (SELECT COUNT(*) FROM Course WHERE TNO = 'TA90023');

-- 30.
SELECT c.CNO, c.NAME, MAX(sc.DEGREE) AS Max_Score, MIN(sc.DEGREE) AS Min_Score, MAX(sc.DEGREE) - MIN(sc.DEGREE) AS Score_Difference
FROM Course c
JOIN score sc ON c.CNO = sc.CNO
GROUP BY c.CNO, c.NAME;

-- 31.
SELECT sc.SNO, COUNT(sc.CNO) AS Courses_Below_75
FROM score sc
WHERE sc.DEGREE < 75
GROUP BY sc.SNO;

-- 32.
SELECT DISTINCT t.TNO, t.TNAME
FROM Teacher t
JOIN Course c ON t.TNO = c.TNO
JOIN score sc ON c.CNO = sc.CNO
WHERE sc.DEGREE < 75;

-- 33.
SELECT s.SNO, s.SNAME
FROM Student s
JOIN score sc ON s.SNO = sc.SNO
GROUP BY s.SNO, s.SNAME
HAVING COUNT(DISTINCT sc.CNO) < 2;

-- 34.
SELECT sc.SNO
FROM score sc
WHERE NOT EXISTS (
    SELECT c.CNO
    FROM score c
    WHERE c.SNO = 'PB210000001'
    AND c.CNO NOT IN (
        SELECT sc2.CNO
        FROM score sc2
        WHERE sc2.SNO = sc.SNO
    )
)
GROUP BY sc.SNO
HAVING COUNT(DISTINCT sc.CNO) >= (
    SELECT COUNT(DISTINCT c.CNO)
    FROM score c
    WHERE c.SNO = 'PB210000001'
);


-- 35.
SELECT c.NAME, AVG(sc.DEGREE) AS Average_Score
FROM Course c
LEFT JOIN score sc ON c.CNO = sc.CNO
GROUP BY c.NAME;

-- 36.
SELECT s.DEPART, COUNT(DISTINCT s.SNO) AS Total_Students, AVG(sc.DEGREE) AS Average_Score
FROM Student s
LEFT JOIN score sc ON s.SNO = sc.SNO
GROUP BY s.DEPART;

-- 37.
SELECT DISTINCT s.SNAME
FROM Student s
WHERE s.SNO NOT IN (
    SELECT sc.SNO
    FROM score sc
    JOIN Course c ON sc.CNO = c.CNO
    WHERE c.NAME IN ('DB_Design', 'Data_Mining')
);

-- 38.
SELECT c.NAME, MIN(YEAR(CURDATE()) - YEAR(s.BIRTHDAY)) AS Min_Age, 
       MAX(YEAR(CURDATE()) - YEAR(s.BIRTHDAY)) AS Max_Age, 
       AVG(YEAR(CURDATE()) - YEAR(s.BIRTHDAY)) AS Avg_Age
FROM Course c
LEFT JOIN score sc ON c.CNO = sc.CNO
LEFT JOIN Student s ON sc.SNO = s.SNO
GROUP BY c.NAME;

-- 39.
SELECT DISTINCT s.SNO, s.SNAME
FROM Student s
JOIN score sc ON s.SNO = sc.SNO
JOIN Course c ON sc.CNO = c.CNO
WHERE c.NAME LIKE '%Computer%';

-- 40.
SELECT sc.SNO, sc.CNO, sc.DEGREE
FROM score sc
JOIN (
    SELECT c.CNO, AVG(sc.DEGREE) AS Avg_Degree
    FROM Course c
    JOIN score sc ON c.CNO = sc.CNO
    GROUP BY c.CNO
) AS avg_scores ON sc.CNO = avg_scores.CNO
WHERE sc.DEGREE BETWEEN (avg_scores.Avg_Degree - 12) AND (avg_scores.Avg_Degree + 12);

-- 41.
CREATE VIEW db_229_student AS
SELECT *
FROM Student
WHERE DEPART = '229'
WITH CHECK OPTION;

-- 42.
UPDATE db_229_student
SET SNAME = 'CSQ'
WHERE SNO = 'PB210000020';

-- 43.
SELECT SNO, SNAME
FROM db_229_student
WHERE YEAR(CURDATE()) - YEAR(BIRTHDAY) < 22;

-- 44.
INSERT INTO Student (SNO, SNAME, Gender, BIRTHDAY, DEPART)
VALUES ('SA210110021', 'QXY', 'female', '2007-07-27', '229');
SELECT * FROM db_229_student;

-- 45.
INSERT INTO db_229_student (SNO, SNAME, Gender, BIRTHDAY, DEPART)
VALUES ('SA210110023', 'DPC', 'male', '1997-04-27', '11');

-- 46.
DROP VIEW db_229_student;

-- 47.
CREATE TABLE teacher_salary (
    TNO VARCHAR(20),
    SAL FLOAT,
    PRIMARY KEY (TNO)
);

-- 48. 
DELIMITER $$
CREATE TRIGGER check_teacher_existence_before_insert
BEFORE INSERT ON teacher_salary
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Teacher WHERE TNO = NEW.TNO) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: TNO does not exist in the Teacher table.';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER check_teacher_existence_before_update
BEFORE UPDATE ON teacher_salary
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Teacher WHERE TNO = NEW.TNO) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: TNO does not exist in the Teacher table.';
    END IF;
END$$
DELIMITER ;

-- 49.
DELIMITER $$
CREATE TRIGGER salary_range_before_insert
BEFORE INSERT ON teacher_salary
FOR EACH ROW
BEGIN
    DECLARE position VARCHAR(100);
    SELECT POSITION INTO position FROM Teacher WHERE TNO = NEW.TNO;
    CASE
        WHEN position = 'Instructor' THEN
            SET NEW.SAL = CASE
                WHEN NEW.SAL < 4000 THEN 4000
                WHEN NEW.SAL > 7000 THEN 7000
                ELSE NEW.SAL
            END;
        WHEN position = 'Associate Professor' THEN
            SET NEW.SAL = CASE
                WHEN NEW.SAL < 7000 THEN 7000
                WHEN NEW.SAL > 10000 THEN 10000
                ELSE NEW.SAL
            END;
        WHEN position = 'Professor' THEN
            SET NEW.SAL = CASE
                WHEN NEW.SAL < 10000 THEN 10000
                WHEN NEW.SAL > 13000 THEN 13000
                ELSE NEW.SAL
            END;
    END CASE;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER salary_range_before_update
BEFORE UPDATE ON teacher_salary
FOR EACH ROW
BEGIN
    DECLARE position VARCHAR(100);
    SELECT POSITION INTO position FROM Teacher WHERE TNO = NEW.TNO;
    CASE
        WHEN position = 'Instructor' THEN
            SET NEW.SAL = CASE
                WHEN NEW.SAL < 4000 THEN 4000
                WHEN NEW.SAL > 7000 THEN 7000
                ELSE NEW.SAL
            END;
        WHEN position = 'Associate Professor' THEN
            SET NEW.SAL = CASE
                WHEN NEW.SAL < 7000 THEN 7000
                WHEN NEW.SAL > 10000 THEN 10000
                ELSE NEW.SAL
            END;
        WHEN position = 'Professor' THEN
            SET NEW.SAL = CASE
                WHEN NEW.SAL < 10000 THEN 10000
                WHEN NEW.SAL > 13000 THEN 13000
                ELSE NEW.SAL
            END;
    END CASE;
END$$
DELIMITER ;

-- 50.
DROP TRIGGER IF EXISTS check_teacher_existence_before_insert;
DROP TRIGGER IF EXISTS check_teacher_existence_before_update;
DROP TRIGGER IF EXISTS salary_range_before_insert;
DROP TRIGGER IF EXISTS salary_range_before_update;

-- 51.
UPDATE score
SET DEGREE = NULL
WHERE CNO = (SELECT CNO FROM Course WHERE NAME = 'Data_Mining');
SELECT SNO, DEGREE
FROM score
ORDER BY DEGREE ASC;

-- 52.
SELECT s.SNO, s.SNAME, COUNT(sc.CNO) AS Courses_Count
FROM Student s
JOIN score sc ON s.SNO = sc.SNO
GROUP BY s.SNO, s.SNAME
ORDER BY Courses_Count DESC
LIMIT 1;

-- 53.
SELECT t.TNO, t.TNAME, COUNT(DISTINCT sc.SNO) AS Total_Students
FROM Teacher t
JOIN Course c ON t.TNO = c.TNO
JOIN score sc ON c.CNO = sc.CNO
GROUP BY t.TNO, t.TNAME
ORDER BY Total_Students DESC
LIMIT 1;
