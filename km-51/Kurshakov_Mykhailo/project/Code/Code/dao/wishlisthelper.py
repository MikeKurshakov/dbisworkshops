import cx_Oracle
from dao.credentials import *

def getWishList(login):

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'select * from table(WISH_LIST_WORK.GET_WISH_LIST(\'%s\'))' % login
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()
    return result

def deleteWishListItem(login,id):

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("WISH_LIST_WORK.DELETE_WISH_LIST_ITEM", cx_Oracle.NUMBER, [id,login])

    cursor.close()
    connection.close()
    return result

def addWishListItem(login,id):

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("WISH_LIST_WORK.add_wish_list_item", cx_Oracle.NUMBER, [id,login])

    cursor.close()
    connection.close()
    return result