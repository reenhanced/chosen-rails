# harvesthq seems reluctant to add support for HTML required fields, so I've taken this from the latest fix
# patch: https://github.com/adcSTUDIO/chosen/compare/harvesthq:master...master
# discussion: https://github.com/harvesthq/chosen/issues/515
$ = jQuery

$.fn.extend({
  chosen: (options) ->
    # Do no harm and return as soon as possible for unsupported browsers, namely IE6 and IE7
    # Continue on if running IE document type but in compatibility mode
    return this unless AbstractChosen.browser_is_supported()
    this.each (input_field) ->
      $this = $ this
      chosen = $this.data('chosen')
      if options is 'destroy' && chosen
        chosen.destroy()
      else unless chosen
        $this.data('chosen', new ChosenWithValidation(this, options))

      return

})

class ChosenWithValidation extends Chosen
  field_invalid: (evt) ->
    @form_field_jq.css({
      position: 'absolute',
      display: ''
    })
    @form_field_jq.css({
      height: @container.height() + 'px',
      width: @container.width() + 'px',
      marginTop: (@container.position().top - @form_field_jq.position().top ) + 'px'
    })
    .bind "change.chzn-valid", (evt) => this.field_valid(evt)

  field_valid: (evt) ->
    if @form_field.validity && @form_field.validity.valid
      @form_field_jq.hide().unbind "change.chzn-valid"

  register_observers: ->
    @form_field_jq.bind "invalid.chosen", (evt) => this.field_invalid(evt)
    super
