// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import 'bootstrap'
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import "channels"
require('jquery')



Rails.start()
Turbolinks.start()


$(document).ready(function () {
  $("#submitButton").on("click", function (e) {
    e.preventDefault();
    const email  = $('#email').val()
    $.ajax({
      url: "/contact_us",
      beforeSend: function (xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')) },
      type: "POST",
      data: {
        email: email
      },
    })
      .done(function (data) {
        console.log('data', data)
      });
  })
});
