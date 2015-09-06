Template.loadRuleModal.onCreated ->
  # @myRulesSub = @subscribe "myRules"
  @selectedRule = new ReactiveVar null
  # if @myRulesSub.ready()


Template.loadRuleModal.helpers
  isActive: ->
    Template.instance().selectedRule.get() is @._id
  listRules: ->
    Rules.find({})
  nothingSelected: ->
    not Template.instance().selectedRule.get()?
  showWarning: ->
    localNodes.find().count()

  momentFormat: (arg) ->
    return moment(arg).format('MMM DD, YYYY HH:mm:ss')

Template.loadRuleModal.events
  "click .list-group-item": (e, t) ->
    e.preventDefault()
    e.stopPropagation()
    t.selectedRule.set @._id

  "click #loadSelectedRuleBtn, dblclick .list-group-item": (e, t) ->
    unless $(e.target).hasClass("disabled")
      Session.set "ruleMaker.ruleID", t.selectedRule.get()
      ## Empty the local nodes and edges , etc. etc.
      localNodes.remove({})
      localEdges.remove({})
      localDataDesc.remove({})
      localPrefs.remove({})
      ## Now load the local stuff from loaded rule
      loadedRule = Rules.findOne({_id: t.selectedRule.get()})
      for item in loadedRule.localNodes
        localNodes.insert item
      for item in loadedRule.localEdges
        localEdges.insert item
      for item in loadedRule.localDataDesc
        localDataDesc.insert item
      for item in loadedRule.localPrefs
        localPrefs.insert item

      Modal.hide()
