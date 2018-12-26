from flask_wtf import Form
from wtforms import StringField,   SubmitField,  PasswordField, DateField,SelectField,TextAreaField
from flask import Flask, render_template, request, flash
from wtforms import validators, ValidationError
from dao.userhelper import *


def UserForm():
   class UserForm(Form):
       pass
   login = TextAreaField("Login: ",[
                                    validators.DataRequired("Please enter your name."),
                                    validators.Length(3, 20, "Name should be from 3 to 20 symbols")
                                 ])

   password = TextAreaField("Password:", [
                                             validators.DataRequired("Please enter your password."),
                                             validators.Length(3, 20, "Password should be from 3 to 10 symbols")
                                          ])

   email = TextAreaField("Email: ",[
                                 validators.DataRequired("Please enter your name."),
                                 validators.Email("Wrong email format")
                                 ])
   roles = getRoles()
   role = SelectField(u'Role',[
                                    validators.DataRequired("Please enter your name.")],choices=[(item[1], item[1]) for item in roles])
   first_name = TextAreaField("First name: ",[
                                    validators.DataRequired("Please enter your name."),
                                    validators.Length(3, 20, "Name should be from 3 to 20 symbols")
                                 ])
   last_name = TextAreaField("Last name: ", [
       validators.DataRequired("Please enter your name."),
       validators.Length(3, 20, "Name should be from 3 to 20 symbols")
   ])

   submit = SubmitField("Register")
   setattr(UserForm, "login", login)
   setattr(UserForm, "password", password)
   setattr(UserForm, "email", email)
   setattr(UserForm, "role", role)
   setattr(UserForm, "first_name", first_name)
   setattr(UserForm, "last_name", last_name)
   setattr(UserForm, "submit", submit)
   return UserForm()

def EditUserForm(login):
   class EditUserForm(Form):
       pass
   user = getUser(login);

   password = TextAreaField("Password:", [
                                             validators.DataRequired("Please enter your password."),
                                             validators.Length(3, 20, "Password should be from 3 to 10 symbols")
                                          ], default = user[0][1])

   email = TextAreaField("Email: ",[
                                 validators.DataRequired("Please enter your name."),
                                 validators.Email("Wrong email format")
                                 ], default = user[0][4])
   first_name = TextAreaField("First name: ",[
                                    validators.DataRequired("Please enter your name."),
                                    validators.Length(3, 20, "Name should be from 3 to 20 symbols")
                                 ], default = user[0][2])
   last_name = TextAreaField("Last name: ", [
       validators.DataRequired("Please enter your name."),
       validators.Length(3, 20, "Name should be from 3 to 20 symbols")
   ],default = user[0][3])

   submit = SubmitField("Modify")

   setattr(EditUserForm, "login", user[0][0])
   setattr(EditUserForm, "password", password)
   setattr(EditUserForm, "email", email)
   setattr(EditUserForm, "role", user[0][5])
   setattr(EditUserForm, "first_name", first_name)
   setattr(EditUserForm, "last_name", last_name)
   setattr(EditUserForm, "submit", submit)
   return EditUserForm()
