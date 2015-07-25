Template.diagram.onCreated ->
  Session.set "flowchart.diagram.currentNode", null

  # @currentNode = new ReactiveVar null
  @connectionModeOn = new ReactiveVar false
  @selectedSrc = new ReactiveVar null
  @selectedDest = new ReactiveVar null

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
      "To Begin, Add Some Nodes from Above!"
    else
      ""

  nodes: ->
    return localNodes.find({})

  currentNode: ->
    Session.get "flowchart.diagram.currentNode"
  isCurrentNode: ->
    Session.equals "flowchart.diagram.currentNode", @._id


Template.diagram.events
  "click .node": (e, t) ->
    Session.set "flowchart.diagram.currentNode", @._id
