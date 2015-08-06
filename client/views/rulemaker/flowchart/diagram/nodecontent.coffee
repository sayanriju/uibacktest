Template.nodeContent.onRendered ->
  @$('i[data-toggle="tooltip"]:not(.text-muted)').tooltip({placement: 'auto bottom'})
  # console.log 'rendered'


Template.nodeContent.helpers
  showNodeBar: ->
    Session.equals("flowchart.diagram.connectionModeOn", false) and Session.equals("flowchart.diagram.currentNode", @._id)

  cantBeSrc: ->
    not @opPortsAvailable


Template.nodeContent.events
  "click i.editLabel": (e, t) ->
    # whichNode = $(e.target).data('node-id')
    whichNode = Session.get "flowchart.diagram.currentNode"
    label = localNodes.findOne({_id: whichNode})?.label
    newLabel = prompt "Change Label", label
    return false unless newLabel? ## Cancel on prompt
    localNodes.update {_id: whichNode},
    $set:{
      label: newLabel
    }

  "click i.editProps": (e, t) ->
    alert "Not Yet Implemented!"

  "click i.connectNode": (e, t) ->
    e.stopPropagation()
    return false if $(e.target).hasClass("cantBeSrc")
    Session.set "flowchart.diagram.connectionModeOn", true
    Session.set "flowchart.diagram.selectedSrc", Session.get "flowchart.diagram.currentNode"

  "click i.deleteNode": (e, t) ->
    resp = confirm "Do you really want to DELETE this Node and all its Connections? This action cannot be undone!"
    if resp
      id = $(e.target).data('node-id')
      localNodes.remove _id: id
      ##### Need clever(er) algo to re-increment ports available!!!!

      ## First, list those src nodes which has this node as dest
      for n in localEdges.find({dest: id},{fields: {_id: 0, src: 1}}).fetch()
        ## and increment the op port available for each such src node
        localNodes.update { _id: n.src }, { $inc: { opPortsAvailable: 1 } }
      ## Next, list those dest nodes which has this node as src
      for n in localEdges.find({src: id},{fields: {_id: 0, dest: 1}}).fetch()
        ## and increment the ip port available for each such dest node
        localNodes.update { _id: n.dest }, { $inc: { ipPortsAvailable: 1 } }

      ## Finally we can actually remove the respective edges
      localEdges.remove({$or: [{src: id}, {dest: id}]})
