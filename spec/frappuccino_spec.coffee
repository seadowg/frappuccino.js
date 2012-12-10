describe('Frappuccino', () ->
  it('attaches itself to the window', () ->
    expect(Frappuccino).not.toBeNull()
  )
  
  describe('Helpers', () ->
    describe('new_backbone_event', () ->
      it('returns a new Backbone.Event', () ->
        event = Frappuccino.Helpers.new_backbone_event()
        expect(event.trigger).not.toBeNull()
        expect(event.on).not.toBeNull()
        expect(event.off).not.toBeNull()
      )
    )
  )
)