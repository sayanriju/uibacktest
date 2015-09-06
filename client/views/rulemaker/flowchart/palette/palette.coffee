Template.palette_addableNode.onRendered ->
  # $('li[data-toggle="tooltip"]').tooltip({placement: "auto right"})
  # console.log $('#addableNodeList').size() #append("<span class='fa fa-plus' style='color:black;'></span>")

Template.palette.onCreated ->
  @objectsFromFactory = @subscribe "objectsFromFactory"
  # @whichKlass = new ReactiveVar "Price"
  @posMatrix = [
    [ [25,30], [150,30], [275,30], [400,30] ] # Indictaor / Price
    [ [25,150], [150,150], [275,150], [400,150], [25,270], [150,270], [275,270], [400,270] ] # Signals
    [ [25,400], [150,400], [275,400], [400,400] ] # Order
  ]

Template.palette.onRendered ->
  # Meteor.setTimeout (->
    # console.log $('#addableNodeList').size() #append("<span class='fa fa-plus' style='color:black;'></span>")
  # 1000)


Template.palette.helpers
  addableNodes: (klass) ->
    # klass = Template.instance().whichKlass.get()
    # console.log klass
    # objectFactory.find({'klass': klass}, {fields: {'type': 1}, sort: {'type': 1}})
    objectFactory.find({klass: klass}, {fields: {'type': 1, 'typeLabel': 1, 'klass': 1}, sort: {'type': 1}})

  labelType: (type) ->
    if type[0..5] is "Signal"
      "Signal: " + type[6..]
    else
      type

Template.palette.events
  "change #klassList": (e, t) ->
    t.whichKlass.set e.target.value

  "click label.tree-toggler": (e, t) ->
    $(e.target).parent().siblings('.list-group-item').children('ul.tree').hide(300);
    $(e.target).parent().siblings('.list-group-item').children('span.toggleIcon').removeClass('fa-chevron-up')
    $(e.target).parent().siblings('.list-group-item').children('span.toggleIcon').addClass('fa-chevron-down')
    $(e.target).siblings('span.toggleIcon').toggleClass('fa-chevron-up fa-chevron-down')
    $(e.target).siblings('ul.tree').toggle(300);

  "click #collapseAll": (e, t) ->
    $('ul.tree').hide(300)

  "click .addableNode": (e, t) ->
    type = $(e.target).data('node-type')
    klass = $(e.target).data('node-klass')
    label = prompt "Enter a Label", klass[..2]+"_"+localNodes.find({klass: klass}).count()
    return false unless label? ## Cancel adding node
    newNode = objectFactory.findOne({type: type}, {fields: {_id: 0}})
    delete newNode._id
    newNode.label = label
    newNode.pos = {}
    # posMatrix = Template.instance().posMatrix
    [newNode.pos.top, newNode.pos.left] =
      if newNode.klass is "Signal"
        if t.posMatrix[1].length then t.posMatrix[1].shift() else [-50,50]
      else if newNode.klass is "Price" or newNode.klass[0..8] is "Indicator"
        if t.posMatrix[0].length then t.posMatrix[0].shift() else [-50,150]
      else if newNode.klass is "Order"
        if t.posMatrix[2].length then t.posMatrix[2].shift() else [-50,300]

    localNodes.insert newNode
    # console.log localNodes.find().fetch()
