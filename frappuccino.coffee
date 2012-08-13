class Backbone.EventStream extends Backbone.Event
  constructor: (origin, event) ->
    @origin = origin
    @event = event
    
    @origin.bind(@event, (value) => this.occur(value))
  
  occur: (value) ->
    this.trigger('occur', value)
    
  hook: (func) ->
    this.bind('occur', (value) -> func(value))
    
  map: (func) ->
    pusher = new Backbone.Event()
    this.hook((value) -> pusher.trigger('push', func(value)))
    
    new Backbone.EventStream(pusher, 'push')
    
  filter: (func) ->
    pusher = new Backbone.Event()
    this.hook((value) -> 
      if func(value)
        pusher.trigger('push', value)
    )
    
    new Backbone.EventStream(pusher, 'push')
    
  merge: (event) ->
    pusher = new Backbone.Event()
    this.hook((value) -> pusher.trigger('push', value))
    event.hook((value) -> pusher.trigger('push', value))
    
    new Backbone.EventStream(pusher, 'push')

  