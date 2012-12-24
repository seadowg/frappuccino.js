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
    it('returns an event that occurs with a mapped value of the original', ->
      bb_event = Frappuccino.Helpers.new_backbone_event()
      event = new Frappuccino.Event(bb_event, 'hello')
      mapped = event.map((value) -> value.length)  
      spyOn(mapped, 'trigger')
      event.trigger('occur', 'hello')
    
      expect(mapped.trigger).toHaveBeenCalledWith('occur', 5)
    )
  )
  
  describe('#filter', ->
    it('returns an event that occurs with the correct value if the origin occurrence passes the filter', ->
      bb_event = Frappuccino.Helpers.new_backbone_event()
      event = new Frappuccino.Event(bb_event, 'hello')
      filtered = event.filter((value) -> value >= 1)
      spyOn(filtered, 'trigger')
      
      event.trigger('occur', 0)
      expect(filtered.trigger).not.toHaveBeenCalledWith('occur', 0)
      
      event.trigger('occur', 1)
      expect(filtered.trigger).toHaveBeenCalledWith('occur', 1)
    )
  )
  
  describe('#merge', ->
    it('returns an event that occurs when either of the origin events occur', ->
      bb_event = Frappuccino.Helpers.new_backbone_event()
      event1 = new Frappuccino.Event(bb_event, 'hello')
      event2 = new Frappuccino.Event(bb_event, 'hello_again')
      merged = event1.merge(event2)
      spyOn(merged, 'trigger')
      
      event1.trigger('occur', 1)
      event2.trigger('occur', 2)
      
      expect(merged.trigger).toHaveBeenCalledWith('occur', 1)
      expect(merged.trigger).toHaveBeenCalledWith('occur', 2)
    )
  )
)