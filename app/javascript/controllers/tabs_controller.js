import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

	static values = { 
			match: Number,
			tournament: Number,
			court: { type: Number, default: 1 }
	}

	connect() {
		console.log("-- tabs controller connect")
	}

	setCourtTab() {
		console.log('-- set Court tab value: ' + this.data.get("tabSelectedValue"))
	}
}