describe('Frappuccino.Event', ->
  it('fires an "occur" event when the passed event fires', ->
    bb_event = Frappuccino.Helpers.new_backbone_event()
    event = new Frappuccino.Event(bb_event, 'hello')
    spyOn(event, 'trigger')
    bb_event.trigger('hello', 11)
    
    expect(event.trigger).toHaveBeenCalledWith('occur', 11)
  )
  
  describe('#hook', ->
    it('binds callbacks to the "occur" so they are passed event value when it fires', ->
      bb_event = Frappuccino.Helpers.new_backbone_event()
      event = new Frappuccino.Event(bb_event, 'hello')
      spy = jasmine.createSpy('spy')
      event.hook(spy)
      event.trigger('occur', 'value')
      
      expect(spy).toHaveBeenCalledWith('value')
    )
  )
  
  describe('#occur', ->
    it('triggers the "occur" event with the passed value', ->
      bb_event = Frappuccino.Helpers.new_backbone_event()
      event = new Frappuccino.Event(bb_event, 'hello')
      spyOn(event, 'trigger')
      event.occur('hello')
      
      expect(event.trigger).toHaveBeenCalledWith('occur', 'hello')
    )
  )
  
  describe('#cleanup', ->
    it('stops the event occuring when the origin event does', ->
      bb_event = Frappuccino.Helpers.new_backbone_event()
      event = new Frappuccino.Event(bb_event, 'hello')
      spyOn(event, 'trigger')
      event.cleanup()
      bb_event.trigger('hello', 11)
      
      expect(event.trigger).not.toHaveBeenCalledWith('occur', 11)
    )
    
    it('unbinds all the event\'s callbacks', ->
      bb_event = Frappuccino.Helpers.new_backbone_event()
      event = new Frappuccino.Event(bb_event, 'hello')
      callback = jasmine.createSpy()
      event.bind('occur', callback, event)
      event.cleanup()
      event.trigger('occur')
      
      expect(callback).not.toHaveBeenCalled()
    )
    
    it('triggers cleanup', ->
      bb_event = Frappuccino.Helpers.new_backbone_event()
      event = new Frappuccino.Event(bb_event, 'hello')
      spyOn(event, 'trigger')
      event.cleanup()
      
      expect(event.trigger).toHaveBeenCalledWith('cleanup')
    )
    
    it('is automatically called when the origin event triggers cleanup', ->
      bb_event = Frappuccino.Helpers.new_backbone_event()
      event = new Frappuccino.Event(bb_event, 'hello')     
      spyOn(event, 'trigger')
      bb_event.trigger('cleanup')
      
      expect(event.trigger).toHaveBeenCalledWith('cleanup')
    )
  )
  
  describe('#map', ->
    it('creates an event that occurs with a mapped value of the original', ->
      bb_event = Frappuccino.Helpers.new_backbone_event()
      event = new Frappuccino.Event(bb_event, 'hello')
      mapped = event.map((value) -> value.length)  
      spyOn(mapped, 'trigger')
      event.trigger('occur', 'hello')
    
      expect(mapped.trigger).toHaveBeenCalledWith('occur', 5)
    )
  )
)