Template.nodeContent.helpers
  isCurrentNode: ->
    Session.equals "flowchart.diagram.currentNode", @._id
