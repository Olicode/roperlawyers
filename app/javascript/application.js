import "bootstrap";
import "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";
import Rails from "@rails/ujs";
import "./channels";

window.Stimulus = Application.start();
const context = require.context("./controllers", true, /_controller\.js$/);
window.Stimulus.load(definitionsFromContext(context));
Rails.start();
