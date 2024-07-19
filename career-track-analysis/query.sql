-- 365 Data Science Project: Career Track Analysis
-- https://365datascience.com/projects/career-track-analysis-with-sql-and-tableau/

USE sql_and_tableau;

SELECT * FROM career_track_info;
SELECT * FROM career_track_student_enrollments;

SELECT
    ROW_NUMBER () OVER (ORDER BY student_id) AS student_track_id,
    student_id,
    track_name,
    date_enrolled,
    CASE WHEN date_completed IS NULL THEN 0 ELSE 1 END AS track_completed,
    DATEDIFF(date_completed, date_enrolled) AS days_of_completion,
    CASE
        WHEN DATEDIFF(date_completed, date_enrolled) = 0 THEN 'Same day'
        WHEN DATEDIFF(date_completed, date_enrolled) BETWEEN 1 AND 7 THEN '1 to 7 days' 
        WHEN DATEDIFF(date_completed, date_enrolled) BETWEEN 8 AND 30 THEN '8 to 30 days' 
        WHEN DATEDIFF(date_completed, date_enrolled) BETWEEN 31 AND 60 THEN '31 to 60 days' 
        WHEN DATEDIFF(date_completed, date_enrolled) BETWEEN 61 AND 90 THEN '61 to 90 days'
        WHEN DATEDIFF(date_completed, date_enrolled) BETWEEN 91 AND 365 THEN '91 to 365 days'
        WHEN DATEDIFF(date_completed, date_enrolled) > 365 THEN '366+ days'
    END AS completion_bucket
FROM
    career_track_info i
        JOIN
	career_track_student_enrollments e ON i.track_id = e.track_id;