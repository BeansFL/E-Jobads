display(false);
SELECTED = {
  title: undefined,
  description: undefined,
  payment: undefined,
};

$(function () {
  window.addEventListener("message", (event) => {
    let data = event.data;
    if (data.display === true) {
      display(true);

      if (data.texts) {
        $(".exit-btn").text(data.texts.exitBtnText);
        $(".payment-btn p").text(data.texts.paymentBtnText);
        $(".payment-selection#bank p").text(data.texts.bankPaymentText);
        $(".payment-selection#cash p").text(data.texts.cashPaymentText);
        $(".container-title").html(data.texts.containerTitleText + " - <span id='job'>" + data.job + "</span>");
      }
      if (data.placeholders) {
        $("#title").attr("placeholder", data.placeholders.titlePlaceholder);
        $("#description").attr("placeholder", data.placeholders.descriptionPlaceholder);
      }

      if (data.job) {
        $(".container-title span#job").html(data.job);
      }

      $(".payment-selection").click(function () {
        $(".payment-selection").removeClass("active");
        $(this).addClass("active");
        SELECTED.payment = $(this).attr("id");
      });

      $(".payment-btn").click(function () {
        SELECTED.title = $(".input-box#title").val();
        SELECTED.description = $(".input-box#description").val();
        if (
          SELECTED.title &&
          SELECTED.description &&
          SELECTED.payment
        ) {
          $.post(`https://${GetParentResourceName()}/getData`, JSON.stringify(SELECTED));
          display(false);
          SELECTED.payment = undefined;
        }
      });
      
      $(".exit-btn").click(function () {
        display(false);
        SELECTED.payment = undefined;
      });
      
    } else {
      display(false);
    }
  });
  
  $(document).keydown(function (event) {
    if (event.which == 27) {
      display(false);
      SELECTED.payment = undefined;
    }
  });
});