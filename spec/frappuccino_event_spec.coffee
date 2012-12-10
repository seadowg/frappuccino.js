describe('Frappuccino.Event', () ->
  it('should fire an "occur" event when the passed event fires', () ->
    bb_event = Frappuccino.Helpers.new_backbone_event()
    event = new Frappuccino.Event(bb_event, 'hello')
    spyOn(event, 'trigger')
    bb_event.trigger('hello', 11)
    
    expect(event.trigger).toHaveBeenCalledWith('occur', 11)
  )
)