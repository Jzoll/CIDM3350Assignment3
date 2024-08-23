-- Jessica Zoll
-- CIDM 3350 Assignment #3

USE simpleuniversity;

-- Concat Full name of student 10
-- Concat Semester and year
-- UQ1
SELECT CONCAT(first_name, ' ', last_name) as 'Full Name' , courses_CourseID as 'Course ID', CONCAT(semester, '-', year) as Semester, grade
FROM enrolls_in
INNER JOIN simpleuniversity.students
ON students.ID = students_id
WHERE students_id = 10;

-- UQ1 update
UPDATE enrolls_in
SET grade = 90
WHERE courses_CourseID = 'ACCT-5038';

-- UQ1 display update
SELECT CONCAT(first_name, ' ', last_name) as 'Full Name' , courses_CourseID as 'Course ID', CONCAT(semester, '-', year) as Semester, grade
FROM simpleuniversity.enrolls_in
INNER JOIN simpleuniversity.students
ON students.ID = students_id
WHERE students_id = 10;

-- UQ2 before 
SELECT CONCAT(first_name, ' ', last_name) as 'Stud. Full Name' , courses_CourseID as 'Course ID', year, semester, grade
FROM simpleuniversity.enrolls_in
INNER JOIN simpleuniversity.students
ON students.ID = students_id
WHERE students_id = 900
ORDER BY CONCAT(year, semester) DESC;

-- UQ2 after
INSERT INTO enrolls_in() 
VALUES(900, 'Math-5917', 89, 'Spring', 2012);

-- UQ2 display update
SELECT CONCAT(first_name, ' ', last_name) as 'Stud. Full Name' , courses_CourseID as 'Course ID', year, semester, grade
FROM simpleuniversity.enrolls_in
INNER JOIN simpleuniversity.students
ON students.ID = students_id
WHERE students_id = 900
ORDER BY CONCAT(year, semester) DESC;

-- UQ3 updated email
UPDATE students
SET email = CONCAT(last_name, '_', LEFT(first_name, 2), '@cidm.wtamu.edu')
WHERE departments_DepID_Major = '2';

-- UQ3 display students with updated email
SELECT id, first_name, last_name, email, gender, DoB, Address, SSN, departments_DepID_Minor, departments_DepID_Major
FROM simpleuniversity.students
INNER JOIN simpleuniversity.departments
ON DepID = departments_DepID_Major
WHERE simpleuniversity.departments.DNAME = 'Department of Computer Information and Decision Management';

-- UQ3 alternative method to show data
SELECT * FROM simpleuniversity.students
WHERE departments_DepID_Major = 2;

-- IQ1 DoB of the youngest and oldest student of each department
SELECT DName AS 'Department name', MIN(DoB) AS 'Oldest', MAX(DoB) AS 'Youngest'
FROM students s JOIN departments d ON (d.DepID = s.departments_DepID_Major)
GROUP BY s.departments_DepID_Major;

-- IQ2 List professor name(professors), email address(professors), affiliated department name of the professors (departments/professors), courses taught(taught_by)
-- who taught courses of 6000 level in the year 2010.
SELECT Profname, email, dName, courses_CourseID AS 'courseID'
FROM professors
JOIN departments ON (DepID=departments_DepID_affeliation)
JOIN taught_by ON (ProfID=professors_ProfID)
WHERE RIGHT(courses_CourseID, 4) IN 
(
SELECT RIGHT(CourseID, 4)
FROM courses
WHERE RIGHT(CourseID, 4) >= 6000
) 
AND taught_by.year = 2010
ORDER BY Profname ASC;

-- IQ3- List Female student names and their average grades in each year for students who major in
-- 'Department of Accounting, Economics and Finance' and for the years 2009 and 2012 (only these two years)
SELECT CONCAT(s.first_name, ' ', s.last_name) AS `Stud. Full Name`, en.Year, AVG(en.grade) AS `Avg. Grade`
FROM students s
JOIN enrolls_in en ON s.id = en.students_id
JOIN departments d ON s.departments_DepID_Major = d.DepID
WHERE s.gender = 'Female'
  AND d.dName = 'Department of Accounting, Economics and Finance'
  AND en.Year IN (2009, 2012)
GROUP BY `Stud. Full Name`, en.Year
ORDER BY `Stud. Full Name` ASC;

-- IQ4- Same as IQ3 above, but list only those Female students whose grade average was greater than 80
SELECT CONCAT(s.first_name, ' ', s.last_name) AS `Stud. Full Name`, en.Year, AVG(en.grade) AS `Avg. Grade`
FROM students s
JOIN enrolls_in en ON s.id = en.students_id
JOIN departments d ON s.departments_DepID_Major = d.DepID
WHERE s.gender = 'Female'
  AND d.dName = 'Department of Accounting, Economics and Finance'
  AND en.Year IN (2009, 2012)
GROUP BY `Stud. Full Name`, en.Year
HAVING `Avg. Grade` > 80
ORDER BY `Stud. Full Name` ASC;

-- IQ5- List students’ ids, first and last names, their major department name, and their average grade of all
-- courses they took, showing students with highest average first. (Note that students who didn’t take any
-- course should not be listed, see the sample output below)
SELECT s.id, s.first_name, s.last_name, d.dname, AVG(en.grade) AS `Average Grade`
FROM students s
JOIN enrolls_in en ON s.id = en.students_id
JOIN departments d ON s.departments_DepID_Major = d.DepID
GROUP BY s.id
HAVING AVG(en.grade) IS NOT NULL
ORDER BY `Average Grade` DESC;
