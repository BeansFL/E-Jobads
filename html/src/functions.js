function display(bool) {
  if (bool) {
    $(".main-container").show();
    $("input#title").focus();
  } else {
    $(".main-container").hide();
    $("input").val('');
    $("textarea").val('');
    $.post(`https://${GetParentResourceName()}/exit`);
    $(".payment-selection").removeClass("active");
  }
}