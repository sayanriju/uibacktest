Meteor.methods
  "saveRule": (obj) ->
    unless Meteor.userId()
      throw new Meteor.Error("not-logged-in", "You need to be logged in to do this")

    obj.name = "Rule#"+Random.hexString(6)
    obj.savedAt = new Date()
    obj.userId = Meteor.userId()
    obj.hasResult =  false
    # console.log obj
    ruleID = Rules.insert obj
    return ruleID

  "upsertRule": (obj) ->
    unless Meteor.userId()
      throw new Meteor.Error("not-logged-in", "You need to be logged in to do this")

    if obj.ruleID?  ## INSERT mode
      obj.name = "Rule#"+Random.hexString(6)
      obj.savedAt = new Date()
      obj.userId = Meteor.userId()
      obj.hasResult =  false
      # console.log obj
      ruleID = Rules.insert obj
      return ruleID

    else          ## UPDATE Mode
      ## Check if same user's rule
      if Rules.findOne({_id: obj.ruleID})?.userId is Meteor.userId()
        obj.savedAt = new Date()
        obj.hasResult = false
        Rules.update({_id: obj.ruleID}, {$set: obj})
        return obj.ruleID
      else
        throw new Meteor.Error("wrong-user", "This is not your Rule to save")
