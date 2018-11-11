--Populate userroles table
INSERT INTO userroles(role_id, role_definiton)
VALUES('1000','admin');
INSERT INTO userroles(role_id, role_definiton)
VALUES('1002','editor');
INSERT INTO userroles(role_id, role_definiton)
VALUES('1004','user');

--Populate users table
INSERT INTO users(user_login, role_id_fk,user_password,user_first_name,user_last_name,user_email)
VALUES('admin1','1000','adminadmin1','Admin','Admin','admin1.admin1@mail.com');
INSERT INTO users(user_login, role_id_fk,user_password,user_first_name,user_last_name,user_email)
VALUES('editor1','1002','editoreditor1','Editor','Editor','editor1.editor1@mail.com');
INSERT INTO users(user_login, role_id_fk,user_password,user_first_name,user_last_name,user_email)
VALUES('user1','1004','user1user1','User','User','user1.user1@mail.com');

--Populate section table
INSERT INTO section(SECTION_NAME)
VALUES('Section 1');
INSERT INTO section(SECTION_NAME)
VALUES('Section 2');
INSERT INTO section(SECTION_NAME)
VALUES('Section 3');

--Populate article table
INSERT INTO article(ARTICLE_ID,ARTICLE_HEADER,ARTICLE_TEXT,section_name_fk)
VALUES('101','New header1.','Some text data 1.','Section 1');
INSERT INTO article(ARTICLE_ID,ARTICLE_HEADER,ARTICLE_TEXT,section_name_fk)
VALUES('102','New header2.','Some text data 2.','Section 2');
INSERT INTO article(ARTICLE_ID,ARTICLE_HEADER,ARTICLE_TEXT,section_name_fk)
VALUES('103','New header3.','Some text data 3.','Section 3');

--Populate wish_list table
INSERT INTO wish_list(article_id_fk,user_login_fk,section_name_fk,role_id_fk)
VALUES('101','admin1','Section 1','1000');
INSERT INTO wish_list(article_id_fk,user_login_fk,section_name_fk,role_id_fk)
VALUES('102','admin1','Section 2','1000');
INSERT INTO wish_list(article_id_fk,user_login_fk,section_name_fk,role_id_fk)
VALUES('103','editor1','Section 3','1002');

--Populate article_author table
INSERT INTO article_author(article_id_fk,user_login_fk,section_name_fk,role_id_fk)
VALUES('101','admin1','Section 1','1000');
INSERT INTO article_author(article_id_fk,user_login_fk,section_name_fk,role_id_fk)
VALUES('102','admin1','Section 2','1000');
INSERT INTO article_author(article_id_fk,user_login_fk,section_name_fk,role_id_fk)
VALUES('103','admin1','Section 3','1000');