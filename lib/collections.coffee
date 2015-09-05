@objectFactory = new Mongo.Collection "objectFactory"

Meteor.startup ->
	if Meteor.isServer
		if objectFactory.find({}).count() is 0
			console.log objectFactory.find({}).count()
			for nodeObj in JSON.parse(Assets.getText("nodeTypes.json"))
				objectFactory.insert nodeObj
			console.log "added prototype objects...."
		else
			console.log "Nothing added"

@Rules = new Mongo.Collection "rules"
@Queue = new Mongo.Collection "queue"
@Results = new Mongo.Collection "results" 
