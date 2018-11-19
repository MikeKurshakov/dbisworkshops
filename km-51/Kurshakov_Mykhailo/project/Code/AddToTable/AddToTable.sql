CREATE OR REPLACE PACKAGE add_to_table IS
    FUNCTION get_role_id_by_role_def (
        def userroles.role_definiton%TYPE
    ) RETURN userroles.role_id%TYPE;

    PROCEDURE add_user (
        login         users.user_login%TYPE,
        def           userroles.role_definiton%TYPE,
        pass          users.user_password%TYPE,
        first_name    users.user_first_name%TYPE,
        last_name     users.user_last_name%TYPE,
        local_part    VARCHAR2,
        domain        VARCHAR2
    );

    FUNCTION add_user (
        admin_login   users.user_login%TYPE,
        login         users.user_login%TYPE,
        def           userroles.role_definiton%TYPE,
        pass          users.user_password%TYPE,
        first_name    users.user_first_name%TYPE,
        last_name     users.user_last_name%TYPE,
        local_part    VARCHAR2,
        domain        VARCHAR2
    ) RETURN NUMBER;

    FUNCTION is_user_present (
        login users.user_login%TYPE
    ) RETURN BOOLEAN;

    FUNCTION is_user_can_edit (
        login users.user_login%TYPE
    ) RETURN BOOLEAN;

    FUNCTION is_user_admin (
        login users.user_login%TYPE
    ) RETURN BOOLEAN;

    FUNCTION get_max_article_id RETURN NUMBER;

    FUNCTION add_article (
        author_login   users.user_login%TYPE,
        art_header     article.article_header%TYPE,
        text           article.article_text%TYPE,
        section        article.section_name_fk%TYPE
    ) RETURN NUMBER;

    PROCEDURE add_article (
        author_login   users.user_login%TYPE,
        art_header     article.article_header%TYPE,
        text           article.article_text%TYPE,
        section        article.section_name_fk%TYPE
    );

    PROCEDURE add_section (
        section section.section_name%TYPE
    );

    FUNCTION add_section (
        section section.section_name%TYPE
    ) RETURN NUMBER;

END add_to_table;
/

CREATE OR REPLACE PACKAGE BODY add_to_table IS

    FUNCTION get_role_id_by_role_def (
        def userroles.role_definiton%TYPE
    ) RETURN userroles.role_id%TYPE IS
        res   userroles.role_id%TYPE;
    BEGIN
        SELECT
            role_id
        INTO
            res
        FROM
            userroles
        WHERE
            role_definiton = def;

        RETURN res;
    END get_role_id_by_role_def;

    FUNCTION is_user_present (
        login users.user_login%TYPE
    ) RETURN BOOLEAN IS
        counter   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO
            counter
        FROM
            users
        WHERE
            users.user_login = login;

        IF
            ( counter = 1 )
        THEN
            RETURN true;
        ELSE
            RETURN false;
        END IF;
    END is_user_present;

    FUNCTION get_max_article_id RETURN NUMBER IS
        id_index   NUMBER;
    BEGIN
        SELECT
            MAX(article.article_id)
        INTO
            id_index
        FROM
            article;

        RETURN id_index;
    END get_max_article_id;

    FUNCTION is_user_can_edit (
        login users.user_login%TYPE
    ) RETURN BOOLEAN IS
        counter   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO
            counter
        FROM
            users
            JOIN userroles ON users.role_id_fk = userroles.role_id
        WHERE
            users.user_login = login
            AND   userroles.role_definiton != 'user';

        IF
            ( counter = 1 )
        THEN
            RETURN true;
        ELSE
            RETURN false;
        END IF;
    END is_user_can_edit;

    FUNCTION is_user_admin (
        login users.user_login%TYPE
    ) RETURN BOOLEAN IS
        counter   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO
            counter
        FROM
            users
            JOIN userroles ON users.role_id_fk = userroles.role_id
        WHERE
            users.user_login = login
            AND   userroles.role_definiton = 'admin';

        IF
            ( counter = 1 )
        THEN
            RETURN true;
        ELSE
            RETURN false;
        END IF;
    END is_user_admin;

    FUNCTION add_user (
        admin_login   users.user_login%TYPE,
        login         users.user_login%TYPE,
        def           userroles.role_definiton%TYPE,
        pass          users.user_password%TYPE,
        first_name    users.user_first_name%TYPE,
        last_name     users.user_last_name%TYPE,
        local_part    VARCHAR2,
        domain        VARCHAR2
    ) RETURN NUMBER
        IS
    BEGIN
        IF
            is_user_admin(login) = true
        THEN
            add_user(login,def,pass,first_name,last_name,local_part,domain);
            RETURN 0;
        ELSE
            RETURN 1;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 1;
    END add_user;

    PROCEDURE add_user (
        login         users.user_login%TYPE,
        def           userroles.role_definiton%TYPE,
        pass          users.user_password%TYPE,
        first_name    users.user_first_name%TYPE,
        last_name     users.user_last_name%TYPE,
        local_part    VARCHAR2,
        domain        VARCHAR2
    ) IS
        role_id   users.role_id_fk%TYPE;
    BEGIN
        role_id := get_role_id_by_role_def(def);
        INSERT INTO users (
            user_login,
            role_id_fk,
            user_password,
            user_first_name,
            user_last_name,
            user_email
        ) VALUES (
            login,
            role_id,
            pass,
            first_name,
            last_name,
            local_part
            || '@'
            || domain
        );

        COMMIT;
    END add_user;

    FUNCTION add_article (
        author_login   users.user_login%TYPE,
        art_header     article.article_header%TYPE,
        text           article.article_text%TYPE,
        section        article.section_name_fk%TYPE
    ) RETURN NUMBER
        IS
    BEGIN
        add_article(author_login,art_header,text,section);
        RETURN 0;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 1;
    END add_article;

    PROCEDURE add_article (
        author_login   users.user_login%TYPE,
        art_header     article.article_header%TYPE,
        text           article.article_text%TYPE,
        section        article.section_name_fk%TYPE
    ) IS
        art_id    article.article_id%TYPE;
        role_id   users.role_id_fk%TYPE;
    BEGIN
        IF
            ( is_user_can_edit(author_login) = true )
        THEN
            art_id := get_max_article_id () + 1;
            INSERT INTO article (
                article_id,
                article_header,
                article_text,
                section_name_fk
            ) VALUES (
                art_id,
                art_header,
                text,
                section
            );

            COMMIT;
            SELECT
                role_id_fk
            INTO
                role_id
            FROM
                users
            WHERE
                user_login = author_login;

            INSERT INTO article_author (
                article_id_fk,
                user_login_fk,
                section_name_fk,
                role_id_fk
            ) VALUES (
                art_id,
                author_login,
                section,
                role_id
            );

            COMMIT;
        END IF;
    END add_article;

    PROCEDURE add_section (
        section section.section_name%TYPE
    )
        IS
    BEGIN
        INSERT INTO section ( section_name ) VALUES ( section );

        COMMIT;
    END add_section;

    FUNCTION add_section (
        section section.section_name%TYPE
    ) RETURN NUMBER
        IS
    BEGIN
        add_section(section);
        RETURN 0;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 1;
    END add_section;

END add_to_table;