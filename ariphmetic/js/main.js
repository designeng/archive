window.Router = Backbone.Router.extend({
		
    routes: {
        "": "initExpression",
		"initexpression": "initExpression",
		"stepmaster/:step": "stepMaster"
    },

    initialize: function () {
        this.headerView = new HeaderView();
        $('.header').html(this.headerView.render().el);
    },
	
	initExpression:function () {
				//TODO: toggle
				$('#alltasks').hide();
				$('.practise').removeClass("active");
				$('.initexpression').addClass("active");
				this.initExpressionView = new InitExpressionView();
                $('#initexpr').html(this.initExpressionView.render().el);
    },
	
	stepMaster: function (step) {
					//TODO: toggle
					$('#initexpr').html("");
					$('#alltasks').show();
					$('.initexpression').removeClass("active");
					$('.practise').addClass("active");
					if(step > 3){
						//show success image
						$('#task-' + step).html('<img src="img/done.png" style="border:0"/>');
						setTimeout(function(){
							step = "0";
							clearAllTasksExceptRecent(step);
							app.navigate("stepmaster/0", {trigger: true});
						}, 1500);
						return;					
					}
							
					var model, pattern;
					if(typeof step == "number" && step.charAt(0) == ":") {
						step = step.substr(1);
					}
					
					
					if(typeof step == "undefined" || isNaN(step)) step = "0";
					step = Number(step);
					
					var fractionSumExpression = window.expressionValue;
					
					if(typeof fractionSumExpression == "undefined") fractionSumExpression = "1/4 + 3/7";
					
					var fract = fractionsPrepare(fractionSumExpression);
					model = pattern = new Task({step: step, fractions: [new Fraction({fractionStr: fract[0]}), new Fraction({fractionStr: fract[1]})]});
					//model = pattern = new Task({step: step, fractions: [new Fraction({fractionStr:"1/4"}), new Fraction({fractionStr:"3/7"})]});
					if(step == 2 || step == 3){
						//pattern must be corrected - so, variables input names validation not accurate at this case (TODO)
						var fraction1n = pattern.get("fractions")[0].attributes["numerator"];
						var fraction2n = pattern.get("fractions")[1].attributes["numerator"];
						var mult1 = pattern.get("mult1");
						var mult2 = pattern.get("mult2");
						var commonDenominator = pattern.get("commonDenominator");
					}
					if(step == 2){
						//strings - to match input text model values
						pattern.set("mult1", "" + fraction1n * mult1);
						pattern.set("mult2", "" + fraction2n * mult2);		
						pattern.set("mult3", "" + commonDenominator);
						pattern.set("mult4", "" + commonDenominator);					
					}
					if(step == 3){
						//strings - to match input text model values
						pattern.set("mult1", "" + (fraction1n * mult1 + fraction2n * mult2));	
						pattern.set("mult3", "" + commonDenominator);				
					}
					
					var patternJSON = JSON.stringify(pattern.toJSON());
					
					//alert($('#task-' + (step-1)).html());
					
					model.bind('change', function () {
						var modelJSON = JSON.stringify(model.toJSON())
						//$('#modelData').html(modelJSON);
						//$('#modelData2').html(patternJSON);
						//this is the main validation inputed values engine poin - model binding does all!
						if(modelJSON === patternJSON) {
							app.navigate("stepmaster/" + (step + 1), {trigger: true});
						}
					});
					  
					stepMasterView = new StepMasterView({model:  model});
					$('#task-' + step).html(stepMasterView.render().el);
					
					if(step == 0) {
						app.navigate("stepmaster/1", {trigger: true});											
					}	
					
					function fractionsPrepare(exp){
						return exp.split("+");						
					}

					function clearAllTasksExceptRecent(step){
						for(var i = 0; i <= 4; i++){
							if(i != step) $('#task-' + i).html("");
						}
					}
	}
	

});

//------------------------------------  loading templates and init router ---------------------------------------------------------
templateLoader.load(["HeaderView"],
    function () {
        app = new Router();
        Backbone.history.start();
    });

//------------------------------------  Handlebars template helpers ---------------------------------------------------------
Handlebars.registerHelper('ifGreateThan', function(v1, v2, options) {
  if(v1 > v2) {
    return options.fn(this);
  }
  return options.inverse(this);
});

Handlebars.registerHelper('ifNotEquial', function(v1, v2, options) {
  if(v1 != v2) {
    return options.fn(this);
  }
  return options.inverse(this);
});