$ ->
  $(".show-password").focus ->
    $(".show-password").each (index, input) ->
      $input = $(input)
      $('.show-password-label').remove()
      $("<label class=\"show-password-label margin-top-10  medium\"/>").append($("<input type='checkbox' class='show-passwordcheckbox' />").click(->
        change = (if $(this).is(":checked") then "text" else "password")
        rep = $("<input type='" + change + "' />").attr("id", $input.attr("id")).attr("name", $input.attr("name")).attr("class", $input.attr("class")).val($input.val()).insertBefore($input)
        $input.remove()
        $input = rep
      )).append($("<span/>").html("<span class='margin-left-5'>Show password</span>")).insertAfter $input
  $("abbr[title]").attr('title': "Required").tooltip title: "Required", placement: "left"

