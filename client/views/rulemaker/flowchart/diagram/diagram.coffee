Template.diagram.onCreated ->
  Session.set "flowchart.diagram.currentNode", null
  Session.set "flowchart.diagram.connectionModeOn", false
  Session.set "flowchart.diagram.selectedSrc", null
  Session.set "flowchart.diagram.selectedDest", null

  # @currentNode = new ReactiveVar null
  # @connectionModeOn = new ReactiveVar false
  # @selectedSrc = new ReactiveVar null
  # @selectedDest = new ReactiveVar null

  @jsPlumbReady = new ReactiveVar false


Template.diagram.onRendered ->
  jsPlumb.ready =>
    @jsPlumbReady.set true
    jsPlumb.setContainer "diagramContainer"
    # jsPlumb.draggable ["block1","block2","block3"], {containment: true}
    @common = ## Common options for connections
      endpoint:"Blank"
      anchor: "AutoDefault"
      connector:"Flowchart"
      paintStyle:{ strokeStyle:"black", lineWidth:2 }
      overlays:[ ["PlainArrow", {location: 1}] ]


  Tracker.autorun =>
    # console.log "autorunning"
    if @jsPlumbReady.get() ## attempt to eradicate occassional "tracker afterFlush errors"

      jsPlumb.reset()

      localEdges.find({}).forEach (edge) =>
        # console.log edge.src, edge.dest
        c = jsPlumb.connect {source: edge.src, target: edge.dest}, @common
        ## Bind dblclick to remove connection
        c.bind "dblclick", (conn, evt) =>
          # evt.stopPropagation()
          # evt.preventDefault()
          # if Session.get "connectionModeOn"
            # jsPlumb.detach conn <-- not req, since plumbing is auto-updated on collection change, which is done below
          localEdges.remove({_id: edge._id})
          ## re-increment ports available
          localNodes.update { _id: edge.src }, { $inc: { opPortsAvailable: 1 } }
          localNodes.update { _id: edge.dest }, { $inc: { ipPortsAvailable: 1 } }
          # else
          #   return false

      localNodes.find({}).forEach (node)->
        jsPlumb.draggable(node._id, {containment: true})


Template.diagram.helpers
  welcomeMessage: ->
    unless localNodes.find({}).count()
      "To Begin, Just Add Some Nodes!"
    else
      ""

  nodes: ->
    return localNodes.find({})

  currentNode: ->
    Session.get "flowchart.diagram.currentNode"
  isCurrentNode: ->
    Session.equals "flowchart.diagram.currentNode", @._id

  connectionModeOn: ->
    Session.get "flowchart.diagram.connectionModeOn"


  cantBeDest: ->
    return false if Session.equals "flowchart.diagram.connectionModeOn", false
    return false if Session.equals "flowchart.diagram.selectedSrc", null
    unless Session.get("flowchart.diagram.selectedDest")?
      return true if Session.equals "flowchart.diagram.selectedSrc", @._id  ## src cannot be same as dest
      return true unless localNodes.findOne(_id: @._id)?.ipPortsAvailable
      ## src and dest are already connected!
      return true if localEdges.find({src: Session.get("flowchart.diagram.selectedSrc"), dest: @._id}).count()

      ## Type specific checkings
      srcType = localNodes.findOne(_id: Session.get("flowchart.diagram.selectedSrc"))?.type
      currentType = localNodes.findOne(_id: @._id)?.type
      ## Src node is Signal type
      if srcType[0..5] is "Signal"
        if srcType[6..] isnt "Filter" ## but not signal filter
          ## then dest can either be a signal combine or an order
          return true unless currentType in ["Order", "SignalCombine"]
        else ## Src is a Signal Filter
          ## then dest cannot be Order
          return true unless currentType is "SignalCombine"
      ## Src node is Indicator type
      if srcType is "Indicator"
        return true unless currentType in ["SignalCrossover", "SignalFilter", "SignalThreshold"]
      ## Src node is Price type
      if srcType is "Price"
        return true unless currentType in ["SignalCrossover", "SignalFilter", "SignalThreshold", "Indicator"]

      ## Src node is


Template.diagram.events
  "click .node": (e, t) ->
    e.stopPropagation()
    if Session.equals "flowchart.diagram.connectionModeOn", false
      ## Just select node
      Session.set "flowchart.diagram.currentNode", @._id
    else
      # console.log "Connection Mode ON"
      return false if Session.equals "flowchart.diagram.selectedSrc", null
      ## Connecting ..........
      if not $(e.target).hasClass("cantBeDest")
        Session.set "flowchart.diagram.selectedDest", @._id
        sourceID = Session.get "flowchart.diagram.selectedSrc"
        targetID = Session.get "flowchart.diagram.selectedDest"
        ## reset session variables
        Session.set "flowchart.diagram.connectionModeOn", false
        Session.set "flowchart.diagram.selectedSrc", null
        Session.set "flowchart.diagram.selectedDest", null
        ## Now make an edge
        edge = {src: sourceID, dest: targetID}
        console.log "Connection!"
        # Meteor.defer ->
        if localEdges.find(edge).count() is 0 ## avoid entering same connection/edge
          localEdges.insert edge ## connection!
          ## Decrement available ports
          localNodes.update { _id: sourceID }, { $inc: { opPortsAvailable: -1 } }
          localNodes.update { _id: targetID }, { $inc: { ipPortsAvailable: -1 } }
          ## Set the destination node as currently selected node
          Session.set "flowchart.diagram.currentNode", targetID


  "click #diagramContainer": (e, t) ->
    # Clear selection as well as connection mode
    Session.set "flowchart.diagram.currentNode", null
    Session.set "flowchart.diagram.connectionModeOn", false
    Session.set "flowchart.diagram.selectedSrc", null
    Session.set "flowchart.diagram.selectedDest", null
