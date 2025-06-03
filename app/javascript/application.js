import "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";
import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import "./channels";
import $ from "jquery";
window.Stimulus = Application.start();
const context = require.context("./controllers", true, /_controller\.js$/);
window.Stimulus.load(definitionsFromContext(context));
Rails.start();
Turbolinks.start();

function activateContactForm() {
  $(
    "#contactModal #successMessageBody, #contactModal #errorMessageBody, #contactModal .ct-spinner"
  ).hide();
  $("#contactForm").on("submit", (e) => {
    e.preventDefault();
    const $form = $(this);

    $form.find(".ct-spinner").show();
    $form.find("button[type=submit]").attr("disabled", "disabled");
    const email = $form.find("[name=email]").val();
    const message = $form.find("[name=message]").val();
    const url = $form.find("[name=url]").val();
    $.ajax({
      url: "/contact_us",
      beforeSend: function (xhr) {
        xhr.setRequestHeader(
          "X-CSRF-Token",
          $('meta[name="csrf-token"]').attr("content")
        );
      },
      type: "POST",
      data: {
        email: email,
        message: message,
        url,
      },
    })
      .fail(function (data) {
        $("#errorMessageBody").show();
        $("#contactFormBody").hide();
        $("#successMessageBody").hide();
        $form.find("button[type=submit]").hide();
      })
      .then(function (data) {
        $form.find("button[type=submit]").hide();
        $("#errorMessageBody").hide();
        $("#contactFormBody").hide();
        $("#successMessageBody").show();
      })
      .done(function (data) {
        $form.find("button[type=submit]").removeAttr("disabled");
      });
  });

  $("#submitButton").on("click", function (e) {
    e.preventDefault();
    const email = $("#email").val();
    $.ajax({
      url: "/contact_us",
      beforeSend: function (xhr) {
        xhr.setRequestHeader(
          "X-CSRF-Token",
          $('meta[name="csrf-token"]').attr("content")
        );
      },
      type: "POST",
      data: {
        email: email,
      },
    }).done(function (data) {
      console.log("data", data);
    });
  });
}

$(document).on("turbo:load", activateContactForm);
$(document).on("turbo:load", () => {
  console.log("Ready");
});
