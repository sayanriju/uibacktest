Template.palette.onCreated ->
  @objectsFromFactory = @subscribe "objectsFromFactory"
  @whichKlass = new ReactiveVar "Price"

Template.palette.onRendered ->
  @$('li[data-toggle="tooltip"]').tooltip({placement: "auto right"})

Template.palette.helpers
  addableNodes: () ->
    klass = Template.instance().whichKlass.get()
    # console.log klass
    # objectFactory.find({'klass': klass}, {fields: {'type': 1}, sort: {'type': 1}})
    objectFactory.find({}, {fields: {'type': 1}, sort: {'type': 1}})

  labelType: (type) ->
    if type[0..5] is "Signal"
      "Signal: " + type[6..]
    else
      type

Template.palette.events
  "change #klassList": (e, t) ->
    t.whichKlass.set e.target.value

  "click .addableNode": (e, t) ->
    type = $(e.target).data('node-type')
    label = prompt "Enter a Label", type[..2]+"_"+localNodes.find({type: type}).count()
    return false unless label? ## Cancel adding node
    newNode = objectFactory.findOne({type: type}, {fields: {_id: 0}})
    delete newNode._id
    newNode.label = label

    localNodes.insert newNode
    # console.log localNodes.find().fetch()
