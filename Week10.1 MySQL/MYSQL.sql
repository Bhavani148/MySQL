CREATE DATABASE practice_db;
SHOW DATABASES;
USE practice_db;
CREATE TABLE archived_students (
	student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SELECT * from university_students;

ALTER TABLE STUDENTS
ADD phone_number VARCHAR(15);

ALTER TABLE STUDENTS
MODIFY last_name VARCHAR(50) NOT NULL;

ALTER TABLE STUDENTS
RENAME TO university_students;

DROP TABLE university_students;

CREATE TABLE courses(
	course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INT CHECK(credits BETWEEN 1 AND 5)
);

CREATE TABLE enrollments(
	enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES university_students(student_id),
    FOREIGN KEY(course_id) REFERENCES courses(course_id)
);

Insert into courses (course_id,course_name,credits)
values (101,"AI",3),
(102,"ML",2),
(103,"DL",3);

insert into enrollments(enrollment_id,student_id,course_id)
values(001,1, 101),  -- John Doe enrolls in Mathematics
       (002,2, 102),  -- Jane Smith enrolls in Science
       (003,3, 103);  -- Alice Johnson enrolls in Computer Science

INSERT INTO archived_students(student_id, first_name, last_name,
email, enrollment_date) SELECT student_id, first_name, last_name, email, enrollment_date from university_students where enrollment_date='2025-08-14';
USE practice_db;


select *  from enrollments;
select * from courses;
INSERT INTO enrollments(student_id, course_id) SELECT student_id from university_students;
SET SQL_SAFE_UPDATES=0;

UPDATE university_students SET last_name='Sanmugam', email='karthis1@gmail.com' where student_id=2;
UPDATE university_students SET enrollment_date='2024-08-15' where student_id=2;

-- Transaction Control Language - Transaction, Savepoint, Rollback, Commit

START TRANSACTION;
-- Insert a new student
INSERT INTO university_students(first_name, last_name, email, enrollment_date)
VALUES ('Subha', 'Karthi', 'subha@gmail.com', '2025-02-20');

-- Savepoint before update
SAVEPOINT before_update;

-- Update email of a university_student
UPDATE university_students SET email='subha1@gmal.com' where student_id=6;

-- Rollback to the savepoint
ROLLBACK TO before_update;

-- Commit remaining changes
COMMIT;

-- SET Constraints
SET FOREIGN_KEY_CHECKS=0;

DELETE from university_students where student_id=6;
SET FOREIGN_KEY_CHECKS=1;

TRUNCATE TABLE students;

ALTER TABLE university_students
DROP COLUMN phone_number;

INSERT INTO university_students(first_name, last_name, email, enrollment_date)
VALUES ('Bhavani', 'Jeyseelan', 'bhavani@gmail.com', '2025-08-14');

INSERT INTO university_students(first_name, last_name, email, enrollment_date)
VALUES ('Karthi', 'Shanmugam', 'karthi@gmail.com', '2025-08-15'),
('Anshika', 'Karthi', 'anshika@gmail.com', '2025-06-18');

SELECT * from university_students;

-- 11) Data Query Language and Data Retrieval Language
-- 1. Basic SELECT Query
-- Fetch all columns from the students table

SELECT * from university_students;

-- 2. SELECT Specific Columns
-- Fetch only students enrolled after a specific data
SELECT first_name from university_students;

-- 3. Where clause
SELECT first_name from university_students WHERE student_id=1;

-- 4. Logical Operators
-- Fetch students enrolled in 2024 with a specific last name

SELECT first_name, last_name, enrollment_date from university_students 
where enrollment_date BETWEEN '2024-01-01' AND '2025-01-01' AND first_name='Karthi';


-- 5. OrderBy
-- Fetch students ordered by enrollment date in descending order
SELECT student_id, first_name, last_name, enrollment_date from university_students 
ORDER BY student_id ASC;

SELECT student_id, first_name, last_name, enrollment_date from university_students 
ORDER BY student_id DESC;

-- 6.Limit
-- fetch the first 5 rows
SELECT first_name, last_name from university_students LIMIT 2;

-- 7. Aggregation with GROUP BY
-- Perform calculation on groups of rows using aggregate functions.
-- Common Aggregate functions:
-- Count(): Counts the number of rows.
-- SUM(): Add up values.
-- AVG(): Calculates the average.
-- MAX(): Finds the maximum value.
-- Min(): Finds the minimum value.alter

-- Count the number of students by enrollment_date
select * from university_students;


SELECT enrollment_date, COUNT(*) AS total_students from university_students
GROUP BY enrollment_date;

ALTER TABLE university_students
ADD marks VARCHAR(3);

ALTER TABLE university_students MODIFY marks int;

UPDATE university_students SET marks=100 where student_id=3;

DELETE FROM university_students where marks=NULL;

UPDATE university_students
SET marks = CASE
	when student_id=1 THEN 99
    when student_id=2 THEN 98
    when student_id=3 THEN 100
    ELSE marks
END
WHERE student_id IN (1,2,3);

select * from university_students;

-- 12) DQL-DRL-2

-- Count the number of students by enrolled_date
SELECT sum(marks) AS total_marks from university_students;

SELECT min(marks) AS min_marks from university_students;

SELECT max(marks) AS max_marks from university_students;

SELECT avg(marks) AS avg_marks from university_students ;

-- Combined Aggregrations
SELECT sum(marks) AS sum_total_marks, min(marks) AS min_marks, max(marks) AS max_marks, 
avg(marks) AS avg_marks from university_students;

SELECT sum(marks) AS sum_total_marks, min(marks) AS min_marks, max(marks) AS max_marks, 
avg(marks) AS avg_marks from university_students GROUP BY student_id;


-- HAVING Clause
-- Fetch enrollment dates with more than 5 students

SELECT enrollment_date, COUNT(*) AS total_students
FROM university_students
GROUP BY enrollment_date
HAVING total_students > 0;

-- Join Query
-- Left Join

select * from enrollments;
SELECT university_students.first_name, enrollments.course_id from university_students
LEFT JOIN enrollments ON university_students.student_id=enrollments.student_id;

-- 14) Join-Inner, Left, Right

-- Inner Joins

-- Fetch students and their associated course names
  INSERT INTO university_students(first_name, last_name,email,enrollment_date,marks) 
  VALUES('Subha','Karthi','subha@gmail.com','2025-09-01',97);
  
  SELECT * from university_students;
   
  SELECT * from courses;
  SELECT university_students.first_name, university_students.last_name, courses.course_name, 
  university_students.student_id FROM university_students 
  INNER JOIN enrollments ON university_students.student_id=enrollments.student_id 
  INNER JOIN courses ON enrollments.course_id=courses.course_id;
  -- We can use INNER JOIN or LEFT JOIN both are same.
  -- LEFT JOIN enrollments ON university_students.student_id=enrollments.student_id 
  -- LEFT JOIN courses ON enrollments.course_id=courses.course_id;
 
 
 -- Right Join
 SELECT university_students.student_id, first_name
 FROM university_students
 RIGHT JOIN enrollments
 ON university_students.student_id=enrollments.student_id
