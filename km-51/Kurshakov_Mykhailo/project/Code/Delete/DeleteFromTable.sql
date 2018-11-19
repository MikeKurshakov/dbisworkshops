CREATE OR REPLACE PACKAGE delete_from_table IS
    PROCEDURE delete_article (
        login        users.user_login%TYPE,
        section      section.section_name%TYPE,
        art_header   article.article_header%TYPE,
        res          OUT BOOLEAN
    );

    FUNCTION delete_article (
        login        users.user_login%TYPE,
        section      section.section_name%TYPE,
        art_header   article.article_header%TYPE
    ) RETURN NUMBER;

END delete_from_table;
/

CREATE OR REPLACE PACKAGE BODY delete_from_table IS

    PROCEDURE delete_article (
        login        users.user_login%TYPE,
        section      section.section_name%TYPE,
        art_header   article.article_header%TYPE,
        res          OUT BOOLEAN
    ) IS
        counter   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO
            counter
        FROM
            users u
            JOIN userroles ur ON u.role_id_fk = ur.role_id
        WHERE
            ur.role_definiton = 'admin'
            AND   u.user_login = login;

        res := false;
        IF
            counter = 1
        THEN
            DELETE FROM article a
            WHERE
                a.article_header = art_header
                AND   a.section_name_fk = section;

            res := true;
        END IF;

    END delete_article;

    FUNCTION delete_article (
        login        users.user_login%TYPE,
        section      section.section_name%TYPE,
        art_header   article.article_header%TYPE
    ) RETURN NUMBER IS
        res   BOOLEAN;
    BEGIN
        delete_article(login,section,art_header,res);
        IF
            res = true
        THEN
            RETURN 0;
        ELSE
            RETURN 1;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 1;
    END delete_article;

END delete_from_table;