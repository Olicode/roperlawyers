// Import and register all your controllers from the importmap under controllers/*

import { application } from "./application"

// Import controllers directly
import ContactController from "./contact_controller"
import ReviewController from "./review_controller"
import UserFormController from "./user_form_controller"

// Register controllers
application.register("contact", ContactController)
application.register("review", ReviewController)
application.register("user-form", UserFormController)
