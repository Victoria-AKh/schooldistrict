--Find all 8 grade student who has given test using Schooloby platform
 
SELECT  s.student_id, s.frist_name ,s.last_name   
FROM	student s
INNER JOIN takes t 
ON t.platform_id=s.platform_id
AND t.platform_id='Schooloby'
AND s.grade=8
Order by s.first_name, s.last_name

--report with using Pass and fail
Select s.student_id, s.frist_name ,s.last_name,
	CASE when t.score>70 then 'pass' else 'fail' end as report
From student s
Inner join takes 
ON t.platform_id=s.platform_id

--find ratio of student pass the exam by grades
with reports as (Select s.student_id, s.frist_name ,s.last_name, s.grade,
					CASE when t.score>70 then 'pass' else 'fail' end as report
				From student s
				Inner join takes 
				ON t.platform_id=s.platform_id)
Select grade, Count(case when report='pass' then 1 else 0 end)::decimal/count(*)*100 as s_ratio
from reports
Group BY grade

--Update grade when student pass the exam
Update student
SET grade = grade+1
from student
inner join (Select s.student_id, s.frist_name ,s.last_name, s.grade,
					CASE when t.score>70 then 'pass' else 'fail' end as report
				From student s
				Inner join takes 
				ON t.platform_id=s.platform_id) as reports
ON student.student_id=reports.student_id
WHERE reports.report='pass'

