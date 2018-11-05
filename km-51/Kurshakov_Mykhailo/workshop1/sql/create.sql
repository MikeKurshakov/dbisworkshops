/*==============================================================*/
/* Table: ARTICLE_AUTHOR                                        */
/*==============================================================*/
CREATE TABLE article_author (
    article_id_fk   NUMBER NOT NULL,
    user_login_fk   VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_article_author PRIMARY KEY ( article_id_fk,
    user_login_fk )
);


/*==============================================================*/
/* Table: Article                                               */
/*==============================================================*/

CREATE TABLE article (
    article_id       NUMBER NOT NULL,
    section_id_fk NUMBER  NOT NULL,
    article_header   VARCHAR2(200) NOT NULL,
    article_text     VARCHAR2(2000) NOT NULL,
    CONSTRAINT pk_article PRIMARY KEY ( article_id )
);


/*==============================================================*/
/* Table: Roles                                                  */
/*==============================================================*/

CREATE TABLE userroles (
    role_id          NUMBER NOT NULL,
    role_definiton   VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_role PRIMARY KEY ( role_id )
);

/*==============================================================*/
/* Table: Section                                               */
/*==============================================================*/

CREATE TABLE section (
    section_id     NUMBER NOT NULL,
    section_name   VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_section PRIMARY KEY ( section_id )
);

/*==============================================================*/
/* Table: Users                                               */
/*==============================================================*/

CREATE TABLE users (
    user_login        VARCHAR2(30) NOT NULL,
    role_id_fk        NUMBER       NOT NULL,
    user_password     VARCHAR2(20) NOT NULL,
    user_first_name   VARCHAR2(50) NOT NULL,
    user_last_name    VARCHAR2(50) NOT NULL,
    user_email        VARCHAR(40) NOT NULL,
    CONSTRAINT pk_user PRIMARY KEY ( user_login )
);


/*==============================================================*/
/* Table: WISH_LIST                                             */
/*==============================================================*/

CREATE TABLE wish_list (
    article_id_fk   NUMBER NOT NULL,
    user_login_fk VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_wish_list PRIMARY KEY ( article_id_fk,
    user_login_fk )
);

/*==============================================================*/
/* Foreing key                                                  */
/*==============================================================*/

ALTER TABLE article_author
    ADD CONSTRAINT fk_article FOREIGN KEY ( article_id_fk )
        REFERENCES article ( article_id ) ON DELETE CASCADE;

ALTER TABLE article_author
    ADD CONSTRAINT fk_author FOREIGN KEY ( user_login_fk )
        REFERENCES users ( user_login ) ON DELETE CASCADE;

ALTER TABLE article
    ADD CONSTRAINT fk_article_section FOREIGN KEY ( section_id_fk )
        REFERENCES section ( section_id ) ON DELETE CASCADE;

ALTER TABLE users
    ADD CONSTRAINT fk_user_has__role FOREIGN KEY ( role_id_fk )
        REFERENCES userroles ( role_id ) ON DELETE CASCADE;

ALTER TABLE wish_list
    ADD CONSTRAINT fk_wish_list_article FOREIGN KEY ( article_id_fk )
        REFERENCES article ( article_id ) ON DELETE CASCADE;

ALTER TABLE wish_list
    ADD CONSTRAINT fk_wish_list_user FOREIGN KEY ( user_login_fk )
        REFERENCES users ( user_login ) ON DELETE CASCADE;

/*==============================================================*/
/* Constraints                                                  */
/*==============================================================*/

ALTER TABLE users ADD CONSTRAINT user_email_unique UNIQUE ( user_email );

ALTER TABLE users
    ADD CONSTRAINT user_email_check CHECK ( REGEXP_LIKE ( user_email,
    '^[a-zA-Z0-9_.+-]{1,20}@[a-zA-Z0-9-]{1,15}\.[a-zA-Z0-9-.]{1,5}$' ) );

ALTER TABLE users
    ADD CONSTRAINT user_login_check CHECK ( REGEXP_LIKE ( user_login,
    '^[A-Z0-9a-z_]{1,30}$' ) );

ALTER TABLE users
    ADD CONSTRAINT user_first_name_check CHECK ( REGEXP_LIKE ( user_first_name,
    '^[A-Z][a-z]{1,49}$' ) );

ALTER TABLE users
    ADD CONSTRAINT user_last_name_check CHECK ( REGEXP_LIKE ( user_last_name,
    '^[A-Z][a-z]{1,49}$' ) );

ALTER TABLE users
    ADD CONSTRAINT user_password_check CHECK ( REGEXP_LIKE ( user_password,
    '^[A-Z0-9a-z_]{8,20}$' ) );

ALTER TABLE users
    ADD CONSTRAINT role_id_fk_check CHECK ( REGEXP_LIKE ( role_id_fk,
    '^\d{1,10}$' ) );

ALTER TABLE section ADD CONSTRAINT section_name_unique UNIQUE ( section_name );

ALTER TABLE section
    ADD CONSTRAINT section_id_check CHECK ( REGEXP_LIKE ( section_id,
    '^\d{1,10}$' ) );

ALTER TABLE section
    ADD CONSTRAINT section_name_check CHECK ( REGEXP_LIKE ( section_name,
    '^[A-Za-z0-9[:blank:]]{1,20}$' ) );

ALTER TABLE userroles
    ADD CONSTRAINT role_id_check CHECK ( REGEXP_LIKE ( role_id,
    '^\d{1,10}$' ) );

ALTER TABLE userroles
    ADD CONSTRAINT role_definiton_check CHECK ( REGEXP_LIKE ( role_definiton,
    '^(admin|editor|user)$' ) );

ALTER TABLE userroles ADD CONSTRAINT role_definiton_unique UNIQUE ( role_definiton );

ALTER TABLE article
    ADD CONSTRAINT article_id_check CHECK ( REGEXP_LIKE ( article_id,
    '^\d{1,10}$' ) );

ALTER TABLE article
    ADD CONSTRAINT article_header_check CHECK ( REGEXP_LIKE ( article_header,
    '^[A-Z0-9a-z[:blank:]]{5,199}\.$' ) );

ALTER TABLE article ADD CONSTRAINT article_header_unique UNIQUE ( article_header );

ALTER TABLE article
    ADD CONSTRAINT article_text_check CHECK ( REGEXP_LIKE ( article_text,
    '^[^\c]{1,2000}$' ) );
    
ALTER TABLE article
    ADD CONSTRAINT section_id_fk_check CHECK ( REGEXP_LIKE ( section_id_fk,
    '^\d{1,10}$' ) );

ALTER TABLE wish_list
    ADD CONSTRAINT wish_list_article_id_fk_check CHECK ( REGEXP_LIKE ( article_id_fk,
    '^\d{1,10}$' ) );

ALTER TABLE wish_list
    ADD CONSTRAINT wish_list_login_fk_check CHECK ( REGEXP_LIKE ( user_login_fk,
    '^[A-Z0-9a-z_]{1,30}$' ) );

ALTER TABLE article_author
    ADD CONSTRAINT author_article_id_fk_check CHECK ( REGEXP_LIKE ( article_id_fk,
    '^\d{1,10}$' ) );

ALTER TABLE article_author
    ADD CONSTRAINT author_login_fk_check CHECK ( REGEXP_LIKE ( user_login_fk,
    '^[A-Z0-9a-z_]{1,30}$' ) );