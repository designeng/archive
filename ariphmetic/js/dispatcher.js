//-------------------------- dispatcher-------------------------------------------//

var dispatcher = {};
_.extend(dispatcher, Backbone.Events);

var receiver = {
    initialize: function() {
        dispatcher.on('error:by zero', this.displayError, this);
		dispatcher.on('error:validation', this.displayValidationError, this);
		dispatcher.on('no errors', this.hideError, this);
		dispatcher.on('redirect to task', this.redirectToTask, this);
    },
    displayError: function(event) {
		$("#error-msg-wrapper").show();
		$("#error-msg").html(event.msg);;
    },
	displayValidationError: function(event) {
		$("#error-msg-wrapper").show();
		$("#error-msg").html(event.msg);
    },
	hideError: function() {
		$("#error-msg-wrapper").hide();
		$("#error-msg").html("");
    },
	redirectToTask: function(event) {
		window.expressionValue = event.exprValue; //TODO
		app.navigate("stepmaster/0", {trigger: true});
	},
	
};

receiver.initialize();