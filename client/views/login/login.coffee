
Template.loginForm.helpers
  loginError: ->
    Session.get("loginErrorMsg")?
  loginErrorMsg: ->
    Session.get "loginErrorMsg"

Template.loginForm.events
  "submit #Login_Form": (e, t) ->
    e.preventDefault()
    e.stopPropagation()
    username = $('#username').val()
    pass = $('#pass').val()
    Meteor.loginWithPassword username, pass, (err) ->
      Session.set "loginErrorMsg", err.reason if err
