INSERT INTO users (
    user_login,
    role_id_fk,
    user_password,
    user_first_name,
    user_last_name,
    user_email
) VALUES (
    'editor2',
    '1002',
    'editoreditor2',
    'Editor',
    'Editor',
    'editor2.editor2@mail.com'
);

INSERT INTO article (
    article_id,
    article_header,
    article_text,
    section_id_fk
) VALUES (
    '104',
    'New header4.',
    'Some text data 4.',
    '10002'
);

INSERT INTO article_author (
    article_id_fk,
    user_login_fk
) VALUES (
    '104',
    'editor2'
);