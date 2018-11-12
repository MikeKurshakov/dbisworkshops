from flask import Flask, render_template, abort, request

app = Flask(__name__)

users = {'user_login': 'admin1',
         'role_id_fk': '1000',
         'user_password':'adminadmin1',
         'user_first_name':'Admin',
         'user_last_name':'Admin',
         'user_email':'admin1.admin1@mail.com'}
wish_list = {'article_id_fk': '101',
            'user_login_fk': 'admin1',
            'section_name_fk': 'Section 1',
            'role_id_fk': '1000'}

@app.route('/')
def index():
    return '<h1>Hello!!!</h1>'

@app.route('/api/action/<actionName>')
def action(actionName):
    if actionName == 'users':
        return render_template('users.html', users=users)
    elif actionName == 'wish_list':
        return render_template('wish_list.html', wish_list=wish_list)
    elif actionName == 'all':
        return render_template('all.html', users=users, wish_list=wish_list)
    else:
        abort(404, actionName)


@app.errorhandler(404)
def error(e):
    return render_template('404.html',action_value=e, available='users, wish_list')


@app.route('/api/action/<entityName>/result', methods=['POST', 'GET'])
def result(entityName):
    if request.method == 'POST':
        result = request.form
        if entityName == 'users':
            global users
            users = result
        elif entityName == 'wish_list':
            global wish_list
            wish_list = result
        return render_template("result.html", result=result)


if __name__ == '__main__':
    app.run(debug=True)
