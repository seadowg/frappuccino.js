window.Frappuccino = {}

Frappuccino.Helpers =
  new_backbone_event: () ->
    event = {}
    _.extend(event, Backbone.Events)
    event
    
class Frappuccino.Pusher
  constructor: (event) ->
    _.extend(this, Backbone.Events)
    @event = event  
    
  finalize: () ->
    this.listenTo(@event, 'occur', this.push)
    this.listenTo(@event, 'cleanup', this.cleanup)
    
    this
  
  push: () -> null
  
  cleanup: () => 
    this.stopListening()
    delete @event
    
    this.trigger('cleanup')
    this.unbind(null, null, this)

class Frappuccino.Event
  constructor: (origin, event) ->
    _.extend(this, Backbone.Events)
    @origin = origin
    @event = event

    this.listenTo(@origin, @event, this.occur)
    this.listenTo(@origin, 'cleanup', this.cleanup)

  hook: (func) ->
    callback = (value) -> func(value)
    this.bind('occur', callback, this)

  occur: (value) =>
    this.trigger('occur', value)

  cleanup: () =>
    this.stopListening()
    delete @origin
    
    this.trigger('cleanup')
    this.unbind(null, null, this)

  map: (func) ->
    pusher = new Frappuccino.Pusher(this)
    pusher.push = (value) -> pusher.trigger('push', func(value))

    new Frappuccino.Event(pusher.finalize(), 'push')

  filter: (func) ->
    pusher = new Frappuccino.Pusher(this)
    pusher.push = (value) ->
      if func(value)
        pusher.trigger('push', value)

    new Frappuccino.Event(pusher.finalize(), 'push')

  merge: (event) ->
    pusher = new Frappuccino.Pusher(this)
    pusher.listenTo(event, 'occur', pusher.push)
    pusher.push = (value) -> pusher.trigger('push', value)
    
    new Frappuccino.Event(pusher.finalize(), 'push')

  replicate: () ->
    pusher = new Frappuccino.Pusher(this)
    this.hook((value) -> pusher.trigger('push', value))

    new Frappuccino.Event(pusher.finalize(), 'push')

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
      replicant.hook(() => this.render())

    this.subscriptions.push(replicant)

    replicant

  render: () ->
    this.preRender() if this.preRender

    if @template
      src = HandlebarsTemplates[@template](this.data())
      @el.html(src)

    this.postRender() if this.postRender
    this

  cleanup: () ->
    subscription.cleanup() for subscription in subscriptions