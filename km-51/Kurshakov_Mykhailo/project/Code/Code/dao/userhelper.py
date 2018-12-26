import cx_Oracle
from dao.credentials import *

def newUser(USER_LOGIN, ROLE_DEFINITION, USER_PASSWORD, FIRST_NAME, LAST_NAME, USER_EMAIL):

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    cursor.callproc("ADD_TO_TABLE.add_user", [USER_LOGIN, ROLE_DEFINITION, USER_PASSWORD, FIRST_NAME, LAST_NAME, USER_EMAIL.split("@")[0],USER_EMAIL.split("@")[1]])

    cursor.close()
    connection.close()

def addUser(admin_login,USER_LOGIN, ROLE_DEFINITION, USER_PASSWORD, FIRST_NAME, LAST_NAME, USER_EMAIL):

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("ADD_TO_TABLE.add_user_v",cx_Oracle.NUMBER, [admin_login,USER_LOGIN, ROLE_DEFINITION, USER_PASSWORD, FIRST_NAME, LAST_NAME, USER_EMAIL.split("@")[0],USER_EMAIL.split("@")[1]])

    cursor.close()
    connection.close()
    return result

def login_user(login, u_password):
        connection = cx_Oracle.connect(username, password, databaseName)
        cursor = connection.cursor()

        result = cursor.callfunc("LOGIN.LOGIN", cx_Oracle.STRING, [login, u_password])

        cursor.close()
        connection.close()
        return result


def is_user_admin(login):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("ADD_TO_TABLE.is_user_admin", cx_Oracle.STRING, [login])

    cursor.close()
    connection.close()
    return result

def is_user_editor(login):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("ADD_TO_TABLE.is_user_can_edit", cx_Oracle.STRING, [login])

    cursor.close()
    connection.close()
    return result

def getUsers():
    connection = cx_Oracle.connect(username, password, databaseName)

    cursor = connection.cursor()

    query = 'select * from table(SHOW_TABLE.get_users_list())'
    cursor.execute(query)
    result = cursor.fetchall()

    cursor.close()
    connection.close()

    return result
def getRoles():

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'select * from table(SHOW_TABLE.get_roles())'
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()
    return result

def getAuthors():

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'select * from table(SHOW_TABLE.get_author_list())'
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()
    return result

def getUser(login):

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'select * from table(SHOW.GET_USER(\'%s\'))' % login
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()
    return result

def updateUser(USER_LOGIN, USER_PASSWORD, FIRST_NAME, LAST_NAME, USER_EMAIL):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("UPDATE_TABLE.UPDATE_USER", cx_Oracle.NUMBER,
                             [ USER_LOGIN, USER_PASSWORD, FIRST_NAME, LAST_NAME,
                              USER_EMAIL.split("@")[0], USER_EMAIL.split("@")[1]])

    cursor.close()
    connection.close()
    return result

def deleteUser(login,user_login):
    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("DELETE_FROM_TABLE.DELETE_USER", cx_Oracle.NUMBER,[ login, user_login])

    cursor.close()
    connection.close()
    return result