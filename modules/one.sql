-- 1
SELECT q.id AS q_id,
    MIN(TIMESTAMP_DIFF(a.creation_date, q.creation_date, SECOND)) as time_to_answer
FROM `bigquery-public-data.stackoverflow.posts_questions` AS q
    FULL JOIN `bigquery-public-data.stackoverflow.posts_answers` AS a
ON q.id = a.parent_id
WHERE q.creation_date >= '2018-01-01' and q.creation_date < '2018-02-01'
GROUP BY q_id
ORDER BY time_to_answer

-- 2
SELECT q.owner_user_id AS owner_user_id,
    MIN(q.creation_date) AS q_creation_date,
    MIN(a.creation_date) AS a_creation_date
FROM `bigquery-public-data.stackoverflow.posts_questions` AS q
    FULL JOIN `bigquery-public-data.stackoverflow.posts_answers` AS a
ON q.owner_user_id = a.owner_user_id 
WHERE q.creation_date >= '2019-01-01' AND q.creation_date < '2019-02-01' 
    AND a.creation_date >= '2019-01-01' AND a.creation_date < '2019-02-01'
GROUP BY owner_user_id

-- 3
SELECT u.id AS id, MIN(q.creation_date) AS q_creation_date, MIN(a.creation_date) AS a_creation_date
FROM `bigquery-public-data.stackoverflow.users` AS u
 LEFT JOIN `bigquery-public-data.stackoverflow.posts_answers` AS a
     ON u.id = a.owner_user_id
 LEFT JOIN `bigquery-public-data.stackoverflow.posts_questions` AS q
     ON q.owner_user_id = u.id
WHERE u.creation_date >= '2019-01-01' and u.creation_date < '2019-02-01'
GROUP BY id