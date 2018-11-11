/*==============================================================*/
/* Table: ARTICLE_AUTHOR                                        */
/*==============================================================*/
create table ARTICLE_AUTHOR 
(
   section_name_fk         VARCHAR2(20)             not null,
   article_id_fk           NUMBER              not null,
   role_id_fk              NUMBER              not null,
   user_login_fk           VARCHAR2(30)             not null,
   constraint PK_ARTICLE_AUTHOR primary key (section_name_fk, article_id_fk, role_id_fk, user_login_fk)
);

/*==============================================================*/
/* Table: Article                                               */
/*==============================================================*/
create table Article 
(
   section_name_fk         VARCHAR2(20)             not null,
   article_id           NUMBER               not null,
   article_header       VARCHAR2(200)        not null,
   article_text         VARCHAR2(2000)       not null,
   constraint PK_ARTICLE primary key (section_name_fk, article_id)
);

/*==============================================================*/
/* Table: Section                                               */
/*==============================================================*/
create table Section 
(
   section_name         VARCHAR2(20)             not null,
   constraint PK_SECTION primary key (section_name)
);

/*==============================================================*/
/* Table: UserRoles                                             */
/*==============================================================*/
create table UserRoles 
(
   role_id              NUMBER              not null,
   role_definiton       VARCHAR2(50)             not null,
   constraint PK_USERROLES primary key (role_id)
);

/*==============================================================*/
/* Table: Users                                                 */
/*==============================================================*/
create table Users 
(
   role_id_fk              NUMBER              not null,
   user_login           VARCHAR2(30)             not null,
   user_password        VARCHAR2(20)              not null,
   user_first_name      VARCHAR2(50)             not null,
   user_last_name       VARCHAR2(50)             not null,
   user_email           VARCHAR2(40)             not null,
   constraint PK_USERS primary key (role_id_fk, user_login)
);

/*==============================================================*/
/* Table: WISH_LIST                                             */
/*==============================================================*/
create table WISH_LIST 
(
   section_name_fk         VARCHAR2(20)             not null,
   article_id_fk           NUMBER              not null,
   role_id_fk              NUMBER              not null,
   user_login_fk           VARCHAR2(30)             not null,
   constraint PK_WISH_LIST primary key (section_name_fk, article_id_fk, role_id_fk, user_login_fk)
);


alter table ARTICLE_AUTHOR
   add constraint FK_ARTICLE foreign key (section_name_fk, article_id_fk)
      references Article (section_name_fk, article_id) ON DELETE CASCADE;

alter table ARTICLE_AUTHOR
   add constraint FK_ARTICLE_USERS foreign key (role_id_fk, user_login_fk)
      references Users (role_id_fk, user_login) ON DELETE CASCADE;

alter table Article
   add constraint FK_ARTICLE_SECTION foreign key (section_name_fk)
      references Section (section_name) ON DELETE CASCADE;

alter table Users
   add constraint FK_USER_HAS__USERROLE foreign key (role_id_fk)
      references UserRoles (role_id) ON DELETE CASCADE;

alter table WISH_LIST
   add constraint FK_WISH_LIST_ARTICLE foreign key (section_name_fk, article_id_fk)
      references Article (section_name_fk, article_id) ON DELETE CASCADE;

alter table WISH_LIST
   add constraint FK_WISH_LIST_USERS foreign key (role_id_fk, user_login_fk)
      references Users (role_id_fk, user_login) ON DELETE CASCADE;
      
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
    ADD CONSTRAINT section_name_fk_check CHECK ( REGEXP_LIKE ( section_name_fk,
    '^[A-Za-z0-9[:blank:]]{1,20}$' ) );

ALTER TABLE wish_list
    ADD CONSTRAINT wish_list_article_id_fk_check CHECK ( REGEXP_LIKE ( article_id_fk,
    '^\d{1,10}$' ) );

ALTER TABLE wish_list
    ADD CONSTRAINT wish_list_login_fk_check CHECK ( REGEXP_LIKE ( user_login_fk,
    '^[A-Z0-9a-z_]{1,30}$' ) );
    
ALTER TABLE wish_list
    ADD CONSTRAINT list_section_name_fk_ch CHECK ( REGEXP_LIKE ( section_name_fk,
    '^[A-Za-z0-9[:blank:]]{1,20}$' ) );

ALTER TABLE wish_list
    ADD CONSTRAINT list_role_id_fk_ch CHECK ( REGEXP_LIKE ( role_id_fk,
    '^\d{1,10}$' ) );

ALTER TABLE article_author
    ADD CONSTRAINT author_article_id_fk_check CHECK ( REGEXP_LIKE ( article_id_fk,
    '^\d{1,10}$' ) );

ALTER TABLE article_author
    ADD CONSTRAINT author_login_fk_check CHECK ( REGEXP_LIKE ( user_login_fk,
    '^[A-Z0-9a-z_]{1,30}$' ) );
    
ALTER TABLE article_author
    ADD CONSTRAINT author_section_name_fk_check CHECK ( REGEXP_LIKE ( section_name_fk,
    '^[A-Za-z0-9[:blank:]]{1,20}$' ) );

ALTER TABLE article_author
    ADD CONSTRAINT author_role_id_fk_check CHECK ( REGEXP_LIKE ( role_id_fk,
    '^\d{1,10}$' ) );

