window.InitExpressionView = Backbone.View.extend({
	//el: "#expression",
	
	_exprValue:undefined,
	
	events: {
    "click #init-exp":          "startTask"
  },
	
    initialize:function () {
		this.template = Handlebars.getTemplate('init-expression');	
    },

    render:function () {		
        $(this.el).html(this.getContent());
        return this;
    },
	
	getContent:function(){
		var content = this.template({});
		return content;
	},
	
	startTask: function(){
		var exprValue = $("#init-expression-input").val();
		if(this.validateInitialFractions(exprValue) && this.validateTerms(exprValue)) dispatcher.trigger('redirect to task', {exprValue: exprValue});
		else dispatcher.trigger('error:common', {msg: "Something wrong!"});
	},
	
	//some initial expression task validations...
	validateInitialFractions: function (exprValue){
		var fractionSign = /((\d*)\/(\d*))/g;
		var intRegex = /^\d+$/;
		var expr = $.trim(exprValue);
			if ( !expr.match(fractionSign)) {
				return false;
			} else if(this.divisionByZero(expr.split("+"))){
				dispatcher.trigger('error:by zero', {msg: "Division by zero!"});
				return false;
			}
		return true;
	},
	
	validateTerms: function (exprValue){
		var arr = exprValue.split("+");
		for(var i = 0, l = arr.length; i < l; i++){
			var term = $.trim(arr[i]);
			if (term === "") {
				dispatcher.trigger('error:validation', {msg: "Missing term!"});
				return false;
			}
			
			if(term % 1 === 0){
				dispatcher.trigger('error:validation', {msg: "Give me a simple fraction please! This is a task not for weak mind!"});
				return false;
			}	
			term = term.replace("/",".");
			if(isNaN(Number(term))){
				dispatcher.trigger('error:validation', {msg: "Give me a fraction please! This is a task not for weak mind!"});
				return false;
			}
		}
		
		return true;
	},
  
  //TODO:regExp
  divisionByZero: function (fractions){
	for(var i = 0, l = fractions.length; i < l; i++){
		var arr = ($.trim(fractions[i])).split("/");
			if (Number(arr[1]) === 0) return true;
	}
	return false;
  }
	
});