Template.palette.onCreated ->
  @objectsFromFactory = @subscribe "objectsFromFactory"


Template.palette.helpers
  addableNodes: (klass) ->
    objectFactory.find({'klass': klass}, {fields: {'type': 1}, sort: {'type': 1}})

  labelType: (type) ->
    if type[0..5] is "Signal"
      "Signal: " + type[6..]
    else
      type

Template.palette.events
  "click .addableNode": (e, t) ->
    type = $(e.target).data('node-type')
    label = prompt "Enter a Label"
    newNode = objectFactory.findOne({type: type}, {fields: {_id: 0}})
    delete newNode._id
    newNode.label = label

    localNodes.insert newNode
    # console.log localNodes.find().fetch()
