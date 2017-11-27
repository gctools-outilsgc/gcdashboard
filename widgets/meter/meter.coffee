class Dashing.Meter extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue
  @accessor 'name', Dashing.Text
  @accessor 'max', Dashing.Text

  constructor: ->
    super
    @observe 'max', (max) ->
      $(@node).attr("data-max", max)
    @observe 'value', (value) ->
      $(@node).find(".meter").val(value).trigger('change')
    @observe 'name', (name) ->
      $(@node).find(".more-info").text(name)

  ready: ->
    meter = $(@node).find(".meter")
    meter.attr("data-bgcolor", meter.css("background-color"))
    meter.attr("data-fgcolor", meter.css("color"))
    meter.knob()
