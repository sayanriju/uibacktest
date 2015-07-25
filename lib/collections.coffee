@objectFactory = new Mongo.Collection "objectFactory"

Meteor.startup ->
	if Meteor.isServer
		if objectFactory.find({}).count() is 0
			console.log objectFactory.find({}).count()
			objectFactory.insert {type: "Indicator", ipPortsAvailable: 1, opPortsAvailable: 999, top: 25, left: 30}
			objectFactory.insert {type: "Order", ipPortsAvailable: 1, opPortsAvailable: 0, top: 150, left: 30}
			objectFactory.insert {type: "Price", ipPortsAvailable: 0, opPortsAvailable: 999, top: 275, left: 30}
			objectFactory.insert {type: "SignalCrossover", ipPortsAvailable: 2, opPortsAvailable: 1, top: 25, left: 150}
			objectFactory.insert {type: "SignalFilter", ipPortsAvailable: 1, opPortsAvailable: 1, top: 150, left: 150}
			objectFactory.insert {type: "SignalThreshold", ipPortsAvailable: 2, opPortsAvailable: 1, top: 275, left: 150}
			objectFactory.insert {type: "SignalCombine", ipPortsAvailable: 2, opPortsAvailable: 1, top: 150, left: 320}
			console.log "added prototype objects...."
		else
			console.log "Nothing added"
