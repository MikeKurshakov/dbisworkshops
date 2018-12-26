from flask_wtf import Form
from wtforms import StringField,   SubmitField,  PasswordField, DateField, TextAreaField,TextField,SelectField,SelectMultipleField,widgets
from dao.articlehelper import *
from dao.userhelper import *
from markupsafe import Markup
from flask import Flask, render_template, request, flash
from wtforms import validators, ValidationError


class ArticleButtonsForm(Form):
   edit_value = Markup('<span class="oi oi-check" title="Edit"></span>')
   edit = SubmitField(edit_value)
   #edit = SubmitField("Edit")
   delete = SubmitField("")

def EditForm(id):
   class EditForm(Form):
      pass
   article = getAricle(id)
   sections = getSections()
   sections.remove((article[0][0],))
   sections.insert(0,(article[0][0],))
   section = SelectField(u'Section',choices=[(item[0], item[0]) for item in sections])
   header = TextAreaField(u'Article header', default = article[0][2])
   text = TextAreaField(u'Article text',default = article[0][3])
   submit = SubmitField("Save")

   setattr(EditForm, "section", section)
   setattr(EditForm, "header", header)
   setattr(EditForm, "text", text)
   setattr(EditForm, "submit", submit)
   setattr(EditForm, "art_id", id)
   return  EditForm()

def AddArticleForm():
   class AddArticleForm(Form):
      pass
   sections = getSections()
   section = SelectField(u'Section',[ validators.DataRequired("Please choose section.")],choices=[(item[0], item[0]) for item in sections])
   header = TextAreaField(u'Article header', [ validators.DataRequired("Please enter header.")])
   text = TextAreaField(u'Article text',[ validators.DataRequired("Please enter text.")])
   submit = SubmitField("Add article")

   setattr(AddArticleForm, "section", section)
   setattr(AddArticleForm, "header", header)
   setattr(AddArticleForm, "text", text)
   setattr(AddArticleForm, "submit", submit)
   return  AddArticleForm()


class MultiCheckboxField(SelectMultipleField):
   widget = widgets.ListWidget(prefix_label=False)
   option_widget = widgets.CheckboxInput()

class FilterArticleForm(Form):
   sections_list = getSections()
   authors_list =  getAuthors()
   authors_list = [(item[1], item[1]) for item in authors_list]
   distinct_authors_list = list(set(authors_list))
   sections = MultiCheckboxField('Sections',coerce = str, choices = [(item[0], item[0]) for item in sections_list],validators = [])
   authors = MultiCheckboxField('Authors', coerce = str, choices=distinct_authors_list,validators=[])
   submit = SubmitField('Search')