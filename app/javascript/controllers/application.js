import { Application } from "@hotwired/stimulus";
import Dropdown from "stimulus-dropdown";

const application = Application.start();
application.register('dropdown', Dropdown);

console.log('-- application.js controller loaded');
// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export { application }
