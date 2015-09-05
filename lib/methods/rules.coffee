Meteor.methods
  "saveRule": (obj) ->
    unless Meteor.userId()
      throw new Meteor.Error("not-logged-in", "You need to be logged in to do this")

    obj.name = "Rule#"+Random.hexString(6)
    obj.savedAt = new Date()
    obj.userId = Meteor.userId()
    # console.log obj
    ruleID = Rules.insert obj
    return ruleID
