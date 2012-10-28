window.Frappuccino = {}

Frappuccino.Helpers =
  new_backbone_event: () ->
    event = {}
    _.extend(event, Backbone.Events)
    event

class Frappuccino.Event
  constructor: (origin, event) ->
    _.extend(this, Backbone.Events)
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
    pusher = Frappuccino.Helpers.new_backbone_event()
    this.hook((value) -> pusher.trigger('push', func(value)))
    
    new Frappuccino.Event(pusher, 'push')
    
  filter: (func) ->
    pusher = Frappuccino.Helpers.new_backbone_event()
    this.hook((value) -> 
      if func(value)
        pusher.trigger('push', value)
    )
    
    new Frappuccino.Event(pusher, 'push')
    
  merge: (event) ->
    pusher = Frappuccino.Helpers.new_backbone_event()
    this.hook((value) -> pusher.trigger('push', value))
    event.hook((value) -> pusher.trigger('push', value))
    
    new Frappuccino.Event(pusher, 'push')
    
  replicate: () ->
    pusher = Frappuccino.Helpers.new_backbone_event()
    this.hook((value) -> pusher.trigger('push', value))
    
    new Frappuccino.Event(pusher, 'push')
    
class Frappuccino.Model extends Backbone.Model
  event: (name) ->
    new Frappuccino.Event(this, name)
    
class Frappuccino.Collection extends Backbone.Collection
  event: (name) ->
    new Frappuccino.Event(this, name)
       
class Frappuccino.View extends Backbone.View
  subscriptions: []
  
  event: (name) ->
    new Frappuccino.Event(this, name)
    
  data: () ->
    {}
  
  subscribe: (event, func) ->
    replicant = event.replicate()
    
    if func
      replicant.hook(func)
    else
      replicant.hook(this.render)
      
    this.subscriptions.push(replicant)
    
    replicant
    
  render: () ->
    this.preRender() if this.preRender 
    
    if @template
      src = HandlebarsTemplates[@template](this.data())
      @el.html(src)
    
    this.postRender() if this.postRender
    
  cleanup: () ->
    subscription.cleanup() for subscription in subscriptions