# Pin npm packages by running ./bin/importmap
# config/importmap.rb

pin "application"
pin "@hotwired/turbo-rails",      to: "turbo.min.js",         preload: true
pin "bootstrap",                  to: "bootstrap.min.js"
pin "@rails/ujs",                 to: "rails-ujs.js"
pin "turbolinks",                 to: "turbolinks.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "jquery",                     to: "jquery.min.js"

