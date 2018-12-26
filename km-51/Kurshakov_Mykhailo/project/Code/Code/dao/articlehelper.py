import cx_Oracle
from dao.credentials import *

def getAricles():

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'select * from table(show_table.get_articles())'
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()
    return result

def getAricle(id):

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'select * from table(show.get_article(%s))' % id
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()
    return result

def getSections():

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()
    query = 'select * from table(SHOW_TABLE.GET_SECTIONS_LIST())'
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()
    return result

def updateArticle(id,section,header,text,author_username):

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("update_table.update_article", cx_Oracle.NUMBER, [id, header, text,section,author_username])

    cursor.close()
    connection.close()
    return result

def deleteArticle(login,id):

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("DELETE_FROM_TABLE.delete_article", cx_Oracle.NUMBER, [login,id])

    cursor.close()
    connection.close()
    return result

def addArticle(section,header,text,author_username):

    connection = cx_Oracle.connect(username, password, databaseName)
    cursor = connection.cursor()

    result = cursor.callfunc("ADD_TO_TABLE.add_article", cx_Oracle.NUMBER, [author_username, header, text,section])

    cursor.close()
    connection.close()
    return result

def filterArticles(sections,authors):
    filter_query = ''
    if sections:
        filter_query += 'a.SECTION_NAME_FK in('
        for item in sections:
            filter_query += ' \'\'%s\'\' , ' % item

        filter_query = filter_query[:-2] + ')'
    if authors:
        if sections :
            filter_query += ' and au.USER_LOGIN_FK in('
        else:
            filter_query += ' au.USER_LOGIN_FK in('
        for item in authors:
            filter_query += ' \'\'%s\'\' , ' % item

        filter_query = filter_query[:-2] + ')'
    print(filter_query)
    if filter_query:
        connection = cx_Oracle.connect(username, password, databaseName)
        cursor = connection.cursor()

        query = 'select * from table(SHOW.FILTER_ARTICLE(\'%s\'))' % filter_query
        cursor.execute(query)
        result = cursor.fetchall()
        cursor.close()
        connection.close()
        return result
    return []