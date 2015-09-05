Template.ruleMaker_layout.onCreated ->
  Session.set "ruleMaker.ruleID", null
  document.title = "Rule Maker"
  @autorun =>
    currentUser = Meteor.userId()
    if currentUser?
      @subscribe "myRules"
      @subscribe "theQueue"
      @subscribe "myResults"

Template.ruleMaker_layout.helpers
  readyToRoll: ->
    not Meteor.loggingIn() and Template.instance().subscriptionsReady()




Template.ruleMaker.onRendered ->
  # console.log $('[rel=tooltip]').size()
  $('[rel=tooltip]:not(".disabled")').tooltip({placement: 'auto bottom'})
  # Meteor.setTimeout ->
  #   $('[rel=tooltip]').tooltip({placement: 'auto bottom'})
  #   console.log $('[rel=tooltip]').size()
  # , 100

Template.ruleMaker.helpers
  ruleName: ->
    if Session.get("ruleMaker.ruleID")?
      Rules.findOne({_id: Session.get("ruleMaker.ruleID")})?.name
    else
      return 'New Rule'
  savedAt: ->
    if Session.get("ruleMaker.ruleID")?
      Rules.findOne({_id: Session.get("ruleMaker.ruleID")})?.savedAt
    else
      return 'Not Yet Saved!'

  isRuleSaved: ->
    !! Session.get("ruleMaker.ruleID")?
  isInQueue: ->
    # return true
    !! Queue.find({_id: Session.get("ruleMaker.ruleID")?}).count()
  canViewResults: ->
    Session.get("ruleMaker.ruleID")? and not Queue.find({_id: Session.get("ruleMaker.ruleID")?}).count()


Template.ruleMaker.events
  "click #addDataDesc, click #addPrefs": (e, t) ->
    alert "Format not yet provided!!!"

  "click #editRuleName": (e, t) ->
    unless $(e.target).hasClass("disabled")
      oldName = Rules.findOne({_id: Session.get("ruleMaker.ruleID")})?.name
      newName = prompt "Enter New Name: ", oldName
      # if newName?

  "click #viewResults": (e, t) ->
    unless $(e.target).hasClass("disabled")
      window.open("google.com")

  "click #loadRule": (e, t) ->
    Modal.show('exampleModal')

  "click #saveRule": (e, t) ->
    unless $(e.target).hasClass("disabled")
      console.log 'foo'
