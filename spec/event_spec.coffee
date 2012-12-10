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
)