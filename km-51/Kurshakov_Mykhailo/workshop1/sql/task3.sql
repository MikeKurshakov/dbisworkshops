DELETE FROM users
WHERE
    user_login IN (
        SELECT
            login
        FROM
            (
                SELECT
                    users.user_login AS login,
                    COUNT(users.user_login)
                FROM
                    users
                    JOIN article_author ON users.user_login = article_author.user_login_fk
                GROUP BY
                    users.user_login
                HAVING
                    COUNT(users.user_login) > 2
            )
    );