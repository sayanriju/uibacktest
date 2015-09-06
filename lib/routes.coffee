FlowRouter.route '/',
  name: "ruleMaker"
  action: () ->
    BlazeLayout.render("ruleMaker_layout");

FlowRouter.route '/results/:ruleID?',
  name: 'viewResults'
  action: ->
    BlazeLayout.render("viewResults_layout")

FlowRouter.route '/logout',
  name: 'logout'
  action: ->
    Meteor.logout (err) ->
      console.log err if err
      FlowRouter.go('ruleMaker')
