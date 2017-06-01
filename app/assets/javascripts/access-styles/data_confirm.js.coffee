$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link) # look bellow for implementations
  false # always stops the action since code runs asynchronously

$.rails.confirmed = (link) ->
  link.removeAttr('data-confirm')
  link.trigger('click.rails')

$.rails.showConfirmDialog = (link) ->
  message = link.attr 'data-confirm'
  confirm_text = link.attr 'data-confirm-text'
  confirm_text = "Ok" unless confirm_text
  cancel_text = link.attr 'data-cancel-text'
  cancel_text = "Cancel" unless cancel_text

  html =  """
          <div class="modal" id="confirmationDialog">
            <div class="modal-dialog">
              <div class="modal-content">
                <p class='pad-10 text-right'><a class="close" data-dismiss="modal">×</a></p>
                <div class="modal-body text-center">
                  #{message}
                </div>
                <div class="modal-footer">
                  <p class='text-center'>
                    <a data-dismiss="modal" class="btn btn-default">#{cancel_text}</a>
                    <a data-dismiss="modal" class="btn btn-success confirm">#{confirm_text}</a>
                  </p>
                </div>
              </div>
            </div>
          </div>
          """
  $(html).modal()
  $('#confirmationDialog .confirm').on 'click', -> $.rails.confirmed(link)
