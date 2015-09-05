Template.ruleMaker_layout.onCreated ->
  Session.set "ruleMaker.ruleID", null
  document.title = "Rule Maker"
  @autorun =>
    currentUser = Meteor.userId()
    if currentUser?
      @subscribe "myRules"
      @subscribe "myQueue"
      @subscribe "hasResult", Session.get("ruleMaker.ruleID")


Template.ruleMaker_layout.helpers
  readyToRoll: ->
    not Meteor.loggingIn() and Template.instance().subscriptionsReady()

###########################################################################

Template.ruleMaker.onCreated ->
  @savingRule = new ReactiveVar false
  @addingToQueue = new ReactiveVar false
  # @autorun =>
  #   if Session.get("ruleMaker.ruleID")?



Template.ruleMaker.onRendered ->
  # console.log $('[rel=tooltip]').size()
  # $('[rel=tooltip]:not(".disabled")').tooltip({placement: 'auto bottom'})
  $('[rel=tooltip]').tooltip({placement: 'auto bottom'})

Template.ruleMaker.helpers
  ruleName: ->
    if Session.get("ruleMaker.ruleID")?
      Rules.findOne({_id: Session.get("ruleMaker.ruleID")})?.name
    else
      return 'New Rule'
  savedAt: ->
    if Session.get("ruleMaker.ruleID")?
      sa = Rules.findOne({_id: Session.get("ruleMaker.ruleID")})?.savedAt
      return "Saved At: " + moment(sa).format('MMM DD, YYYY HH:mm:ss')
    else
      return 'Not Yet Saved!'

  isSavingRule: ->
    Template.instance().savingRule.get()
  isRuleSaved: ->
    !! Session.get("ruleMaker.ruleID")?
  isInQueue: ->
    Session.get("ruleMaker.ruleID")? and Queue.find({ruleID: Session.get("ruleMaker.ruleID")}).count()
  isProcessing: ->
    # return true
    Session.get("ruleMaker.ruleID")? and not Queue.find({ruleID: Session.get("ruleMaker.ruleID")}).count() and not Results.find({ruleID: Session.get("ruleMaker.ruleID")}).count()
  canViewResults: ->
    Session.get("ruleMaker.ruleID")? and Results.find({ruleID: Session.get("ruleMaker.ruleID")}).count() and not Queue.find({ruleID: Session.get("ruleMaker.ruleID")}).count() and not Template.instance().addingToQueue.get()


Template.ruleMaker.events
  "click #addDataDesc, click #addPrefs": (e, t) ->
    alert "Format not yet provided!!!"

  "click #editRuleName": (e, t) ->
    unless $(e.target).hasClass("disabled")
      oldName = Rules.findOne({_id: Session.get("ruleMaker.ruleID")})?.name
      newName = prompt "Enter New Name: ", oldName
      if newName? and newName isnt oldName
        Rules.update  {_id: Session.get("ruleMaker.ruleID")},{$set:{name: newName}}

  "click #viewResults": (e, t) ->
    unless $(e.target).hasClass("disabled")
      unless Results.find({ruleID: Session.get "ruleMaker.ruleID"}).count()
        alert "Results not yet ready!"
      window.open("google.com")

  "click #loadRule": (e, t) ->
    Modal.show('loadRuleModal')

  "click #saveRule": (e, t) ->
    unless $(e.target).hasClass("disabled")
      if Session.get("ruleMaker.ruleID")?
        return unless confirm "A New Rule shall be saved and added to Job Queue.\nPress Cancel if this is not what you want."

      if localNodes.find().count() is 0
        return unless confirm "You haven't added any Nodes to your rule!
        You sure you want to Save this?"
      else if localDataDesc.find().count() is 0
        return unless confirm "You haven't added any Data to your rule!
        You sure you want to Save this?"

      t.savingRule.set(true)
      ruleSaveObj =
        localNodes: localNodes.find({}).fetch()
        localEdges: localEdges.find({}).fetch()
        localDataDesc: localDataDesc.find({}).fetch()
        localPrefs: localPrefs.find({}).fetch()

      Meteor.call "saveRule", ruleSaveObj, (error, ruleID) ->
        if error
          console.log "error", error
          t.savingRule.set(false)
        if ruleID
          Session.set "ruleMaker.ruleID", ruleID
          t.savingRule.set(false)
          ## Add to queue
          t.addingToQueue.set(true)
          Meteor.call "addToQueue", ruleSaveObj, ruleID, (error, result) ->
            if error
              console.log "error", error
            # if result
            t.addingToQueue.set(false)
