UPDATE article
    SET
        article_header = 'New header.'
WHERE
    article_id in (
        SELECT
            article.article_id AS id
        FROM
            article
            FULL OUTER JOIN article_author ON article.article_id = article_author.article_id_fk
        WHERE
            article_author.user_login_fk IS NULL
    );