from flask import Flask, render_template, request, flash, make_response, redirect, session, url_for
import plotly
import plotly.plotly as py
import plotly.graph_objs as go
import numpy as np
import json

from forms.login import LoginForm
from datetime import datetime, timedelta
from forms.user import *
from forms.article import *
from dao.userhelper import *
from dao.articlehelper import *
from dao.wishlisthelper import *

app = Flask(__name__)
app.secret_key = 'development key'

@app.route('/')
def index():
   login_cookie = request.cookies.get('username')
   if 'user_name' in session:
      login_session = session['user_name']
      return 'Logged in as ' + login_session + '<br>' + "<b><a href = '/logout'>click here to log out</a></b>"
   elif login_cookie is not None:
       return 'Logged in as ' + login_cookie + '<br>' + "<b><a href = '/logout'>click here to log out</a></b>"
   return "You are not logged in <br><a href = '/login'></b>" + "click here to log in</b></a>"

@app.route('/home')
@app.route('/home/<section>')
def home(section=[]):
    login = request.cookies.get('username')
    wish_ids = [item[1] for item in getWishList(request.cookies.get('username'))]
    return render_template('index.html', sections=getSections(), articles = filterArticles([section], []), login = login, admin = is_user_admin(login),editor = is_user_editor(login), wish_ids = wish_ids)

@app.route('/profile')
def profile():
    login = request.cookies.get('username')
    return render_template('user_profile.html', login = login, admin = is_user_admin(login), user = getUser(login), editor = is_user_editor(login),)

@app.route('/userinfo/<user_login>')
def user_info(user_login):
    login = request.cookies.get('username')
    return render_template('user_info.html', login = login, admin = is_user_admin(login), user = getUser(user_login), editor = is_user_editor(login),)

@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()

    if request.method == 'GET':
        if 'user_name' not in session:
            return render_template('login.html', form=form)

        login = request.cookies.get('username')
        if login is None:
            return render_template('login.html', form=form)
        return redirect(url_for('index'))

    if request.method == 'POST':
        res = login_user(request.form['login'],request.form['password'])
        if res == '0':
            response = make_response(redirect('/home'))
            expires = datetime.now()
            expires += timedelta(days=60)
            response.set_cookie('username', request.form['login'], expires=expires)
            session['user_name'] = request.form['login']
            return response
        else:
            render_template('login.html', form=form)
    return render_template('login.html', form=form)

@app.route('/getcookie')
def getcookie():
   login = request.cookies.get('username')
   return login

@app.route('/logout')
def delete_cookie():
    response = make_response(redirect('/home'))
    response.set_cookie('username', '', expires=0)
    session.pop('user_name', None)
    return response

@app.route('/adduser', methods=['GET', 'POST'])
def add_user():
    form = UserForm()
    login = request.cookies.get('username')

    if request.method == 'POST':
            res = addUser(                        login,
                                            request.form["login"],
                                            request.form["role"],
                                            request.form["password"],
                                            request.form["first_name"],
                                            request.form["last_name"],
                                            request.form["email"],
                                       )
            if res == 0:
                return redirect('/administration')
            else:
                render_template('add_user.html', form=request.form, action = '/adduser',admin = is_user_admin(login), login = login,editor = is_user_editor(login),)
    return render_template('add_user.html', form=form, action = '/adduser',admin = is_user_admin(login), login = login,editor = is_user_editor(login),)

@app.route('/registration', methods=['GET', 'POST'])
def registration():
    form = UserForm()
    login = request.cookies.get('username')
    if request.method == 'POST':
          res = addUser(                    "admin1",
                                            request.form["login"],
                                            "user",
                                            request.form["password"],
                                            request.form["first_name"],
                                            request.form["last_name"],
                                            request.form["email"],
                                       )
          if res == 0:
                response = make_response(redirect('/home'))
                expires = datetime.now()
                expires += timedelta(days=60)
                response.set_cookie('username', request.form['login'], expires=expires)
                session['user_name'] = request.form['login']
                return response
          else:
              return render_template('add_user.html', form=form, action='/registration',admin = is_user_admin(login), login = login)
    return render_template('add_user.html', form=form,action = '/registration',admin = is_user_admin(login), login = login,editor = is_user_editor(login),)


@app.route('/showallusers', methods=['GET', 'POST'])
def show_users():
    return render_template("result_user.html", result=getUsers())

@app.route('/showallarticles', methods=['GET', 'POST'])
def show_articles():
    login = request.cookies.get('username')
    wish_ids = [item[1] for item in getWishList(request.cookies.get('username'))]
    return render_template("result_article.html", result=getAricles(), admin = is_user_admin(login), editor = is_user_editor(login), wish_ids = wish_ids, login = login )

@app.route('/wishlist', methods=['GET', 'POST'])
def show_wish_list():
    login = request.cookies.get('username')
    return render_template("result_wish_list.html", result=getWishList(request.cookies.get('username')), admin = is_user_admin(login), login = login,editor = is_user_editor(login),)


@app.route('/edit/<id>',methods=['GET', 'POST'])
def edit(id):
    login = request.cookies.get('username')
    if request.method == 'POST':
        res = updateArticle(id,request.form['section'], request.form['header'],request.form['text'],request.cookies.get('username'))
        if res == 0:
            return redirect('/showarticle/%s' % id)
        else:
            render_template('edit_article.html', form=request.form, login = login,admin=is_user_admin(login),editor = is_user_editor(login),)
    return render_template("edit_article.html", form=EditForm(id), login = login,admin=is_user_admin(login),editor = is_user_editor(login),)

@app.route('/delete/<id>', methods=['GET', 'POST'])
def delete(id):
    res = deleteArticle(request.cookies.get('username'),id)
    return redirect('/filterarticle')

@app.route('/addtowishlist/<id>', methods=['GET', 'POST'])
def add_to_wish_list(id):
    res = addWishListItem(request.cookies.get('username'), id)
    if 'showarticle' in request.referrer:
        return redirect('/showarticle/%s' % id)
    return redirect('/showallarticles')

@app.route('/deletewish/<id>', methods=['GET', 'POST'])
def delete_wish_list(id):
    res = deleteWishListItem(request.cookies.get('username'),id)
    if 'showarticle' in request.referrer:
        return redirect('/showarticle/%s' %id)
    if('/showallarticles' in request.referrer):
        return redirect('/showallarticles')
    return redirect('/wishlist')

@app.route('/addarticle',methods=['GET', 'POST'])
def add_article():
    login = request.cookies.get('username')
    if request.method == 'POST':
        res = addArticle(request.form['section'], request.form['header'],request.form['text'],request.cookies.get('username'))
        if res == 0:
            return redirect('/home')
        else:
            render_template('add_article.html', form=request.form,editor = is_user_editor(login),login=login, admin=is_user_admin(login))
    return render_template("add_article.html", form=AddArticleForm(),editor = is_user_editor(login),login=login, admin=is_user_admin(login))

@app.route('/edituser/<user_login>',methods=['GET', 'POST'])
def edit_user(user_login):
    login = request.cookies.get('username')
    if request.method == 'POST':
        res = updateUser(user_login, request.form['password'],request.form['first_name'],request.form['last_name'],request.form['email'])
        if res == 0:
            return  redirect('/administration')
        else:
            render_template('edit_user.html', form=request.form,  login=login, admin=is_user_admin(login),editor = is_user_editor(login))
    return render_template("edit_user.html", form=EditUserForm(user_login),  login=login, admin=is_user_admin(login),editor = is_user_editor(login))

@app.route('/filterarticle',methods=['GET', 'POST'])
def filter_article():
    login = request.cookies.get('username')
    form = FilterArticleForm()
    if request.method == 'POST':
        data = dict(request.form)
        try:
            sections = data['sections']
        except:
            sections = []
        try:
            authors = data['authors']
        except:
            authors = []
        result = filterArticles(sections,authors)
        return render_template("filter_article.html", form=FilterArticleForm(), login=login, admin=is_user_admin(login),result=result,editor = is_user_editor(login))
    return render_template("filter_article.html", form=FilterArticleForm(), login = login, admin = is_user_admin(login), result=[],editor = is_user_editor(login))

@app.route('/showarticle/<id>',methods=['GET', 'POST'])
def show_article(id):
    login = request.cookies.get('username')
    wish_ids = [item[1] for item in getWishList(login)]
    article = getAricle(id)
    return render_template("show_article.html", article = article, login = login, admin = is_user_admin(login),editor = is_user_editor(login), wish_ids = wish_ids)

@app.route('/administration',methods=['GET', 'POST'])
def admin_tab():
    login = request.cookies.get('username')
    result = getUsers();
    return render_template("admin.html", login = login, admin = is_user_admin(login), result = result,editor = is_user_editor(login))

@app.route('/deleteuser/<userlogin>', methods=['GET', 'POST'])
def delete_user(userlogin):
    res = deleteUser(request.cookies.get('username'),userlogin)
    return redirect('/administration')

@app.route('/graphs', methods=['GET'])
def graphs():
    authors_list = getAuthors()
    authors_list = [(item[1]) for item in authors_list]
    articles_list = getAricles()
    sect_list = [(item[0]) for item in articles_list]
    distinct_authors_list = list(set(authors_list))
    distinct_section_list = list(set(sect_list))
    auth_amount = []
    sect_amount = []
    for item in distinct_authors_list:
        auth_amount.append(authors_list.count(item))
    for item in distinct_section_list:
        sect_amount.append(sect_list.count(item))
    count = 500
    x = np.linspace(-np.pi, np.pi, 50)
    y = np.sin(x)


    line = go.Pie(labels=distinct_section_list, values=sect_amount)

    bar = go.Bar(
        x=distinct_authors_list,
        y=auth_amount
    )
    data = [line,bar]
    ids=[1,2]

    graphJSON = json.dumps(data, cls=plotly.utils.PlotlyJSONEncoder)

    return render_template('graphs.html', graphJSON=graphJSON, ids=ids)

if __name__ == '__main__':
    app.run(debug=True)