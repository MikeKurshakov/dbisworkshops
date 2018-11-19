CREATE OR REPLACE PACKAGE show_table IS

    TYPE row_roles IS RECORD ( role_id userroles.role_id%TYPE,
    role_def userroles.role_definiton%TYPE );

    TYPE row_article IS RECORD ( section article.section_name_fk%TYPE,
    art_id article.article_id%TYPE,
    art_header article.article_header%TYPE,
    art_text article.article_text%TYPE );
    
    TYPE row_author_list IS RECORD ( section ARTICLE_AUTHOR.section_name_fk%TYPE,
    login ARTICLE_AUTHOR.USER_LOGIN_FK%TYPE,
    art_header article.article_header%TYPE);
    
    TYPE tbl_roles IS
        TABLE OF row_roles;
    TYPE tbl_articles IS
        TABLE OF row_article;
    TYPE tbl_author_list IS
        TABLE OF row_author_list;
        
    FUNCTION get_roles return tbl_roles
        pipelined;
    FUNCTION get_articles  return tbl_articles
        pipelined;
    FUNCTION get_author_list  return tbl_author_list
        pipelined;
        
END show_table;
/

CREATE OR REPLACE PACKAGE BODY show_table IS

    FUNCTION get_roles  RETURN tbl_roles
        PIPELINED
    IS
        CURSOR my_cur IS SELECT
            *
                         FROM
            userroles;

    BEGIN
        FOR curr IN my_cur LOOP
            PIPE ROW ( curr );
        END LOOP;
        return;
    END get_roles;
    
    FUNCTION get_articles  RETURN tbl_articles 
        PIPELINED
    IS
        CURSOR my_cur IS SELECT
            *
                         FROM
            article;

    BEGIN
        FOR curr IN my_cur LOOP
            PIPE ROW ( curr );
        END LOOP;
        return;
    END get_articles;
    
    FUNCTION get_author_list  RETURN tbl_author_list 
        PIPELINED
    IS
        CURSOR my_cur IS SELECT
            A.SECTION_NAME_FK,AU.USER_LOGIN_FK,A.ARTICLE_HEADER
                         FROM
            article a join ARTICLE_AUTHOR au on A.ARTICLE_ID=AU.ARTICLE_ID_FK;

    BEGIN
        FOR curr IN my_cur LOOP
            PIPE ROW ( curr );
        END LOOP;
        return;
    END get_author_list;

END show_table;