Frappuccino = {}

class Frappuccino.Event extends Backbone.Event
  constructor: (origin, event) ->
    @origin = origin
    @event = event
    
    @origin.bind(@event, this.occur)
    @origin.bind('cleanup', this.cleanup)
    
  hook: (func) ->
    this.bind('occur', (value) -> func(value))
    
  occur: (value) =>
    this.trigger('occur', value)
    
  cleanup: () =>
    @origin.off(@event, this.occur)
    @origin.off('cleanup', this.cleanup)
    delete @origin
    
    this.trigger('cleanup')
    this.off()
    
  map: (func) ->
    pusher = new Backbone.Event()
    this.hook((value) -> pusher.trigger('push', func(value)))
    
    new Frappuccino.Event(pusher, 'push')
    
  filter: (func) ->
    pusher = new Backbone.Event()
    this.hook((value) -> 
      if func(value)
        pusher.trigger('push', value)
    )
    
    new Frappuccino.Event(pusher, 'push')
    
  merge: (event) ->
    pusher = new Backbone.Event()
    this.hook((value) -> pusher.trigger('push', value))
    event.hook((value) -> pusher.trigger('push', value))
    
    new Frappuccino.Event(pusher, 'push')
    
  replicate: () ->
    pusher = new Backbone.Event()
    this.hook((value) -> pusher.trigger('push', value))
    
    new Frappuccino.Event(pusher, 'push')
    
class Frappuccino.View extends Backbone.View
  subscriptions: []
  
  subscribe: (event, func) ->
    replicant = event.replicate()
    replicant.hook(func)
    subscriptions.push(replicant)
    
    replicant
    
  cleanup: () ->
    subscription.cleanup() for subscription in subscriptions