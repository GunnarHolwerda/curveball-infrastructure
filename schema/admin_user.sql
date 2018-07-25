INSERT INTO quizrunner.users
    (user_id, phone, username, photo)
SELECT '00000000-0000-0000-0000-000000000000', '000-000-0000', 'admin', 'https://www.tinygraphs.com/labs/isogrids/hexa/admin?theme=duskfalling&numcolors=4&size=220&fmt=svg'
WHERE NOT EXISTS (
    SELECT user_id FROM quizrunner.users WHERE user_id = '00000000-0000-0000-0000-000000000000'
);