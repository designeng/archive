var StepMasterView = Backbone.View.extend({
				_modelBinder: undefined,
				
				mult1:1,
				mult2:1,
				commonDenominator:1,
								
				events:{
					"blur .mult1": "onBlurMult1",
					"blur .mult2": "onBlurMult2",
					"blur .mult3": "onBlurMult3",
					"blur .mult4": "onBlurMult4"
				},
				
				inputOpentip:undefined,

                initialize:function () {
                    this._modelBinder = new Backbone.ModelBinder();
                },

                close: function(){
                    this._modelBinder.unbind();
                },

                render:function () {
					var step = this.model.get("step");
					
					if(step === 0 || step == 1){
						var leftFractionNumerator = this.model.get("fractions")[0].attributes["numerator"];
						var leftFractionDenominator = this.model.get("fractions")[0].attributes["denominator"];
						var rightFractionNumerator = this.model.get("fractions")[1].attributes["numerator"];
						var rightFractionDenominator = this.model.get("fractions")[1].attributes["denominator"];
						
					}
					
					this.template = Handlebars.getTemplate('step-' + step);
					var html = this.template({operationSign: this.model.get("operationSign"), 
													leftFractionNumerator:leftFractionNumerator,
													leftFractionDenominator:leftFractionDenominator,
													rightFractionNumerator:rightFractionNumerator,
													rightFractionDenominator:rightFractionDenominator,
													equialSign: "=",
													step: step											
													});
					this.$el.html(html);
					
					this.mult1 = this.model.get("mult1");
					this.mult2 = this.model.get("mult2");
					this.commonDenominator = this.model.get("commonDenominator");
					
					//just hide to prevent hint inside input
					this.model.set("mult1", "");
					this.model.set("mult3", "");
					if(step != 3){
						this.model.set("mult2", "");
						this.model.set("mult4", "");
					}
					
					
                    this._modelBinder.bind(this.model, this.el);
					
					//TODO					
					$("input:text:visible:first").focus();

                    return this;
                },
				
				bindOpenTip: function (element, positionInFraction, message){
					Opentip.styles.fractionHint = {
						stem: true,
						containInViewport: false,
						borderWidth: 1,
						borderColor: "#a7c1c5",
						background: "#EFF7F0",
						color: "blue"
					  };
					var tipJoint = (positionInFraction == "numerator") ? "bottom" : "top";
					this.inputOpentip = new Opentip(element, "text", { style: "fractionHint", target: true, tipJoint: tipJoint });
					this.inputOpentip.setContent("<span style='color:red; font-size:14pt;'>" + message + "</span>");
					this.inputOpentip.show();
				},				
				
				validateNumberInput: function (positionInFraction, indexInOperation){
						var msg = "";
						var step = this.model.get("step");
						var element = $("#step-" + step).find("#" + positionInFraction + "-" + step + "-" + indexInOperation);
						var value = $.trim($(element).val());
						var multiplier = this["mult" + indexInOperation];
						if(step == 1){
							if(value != multiplier && value != "") {
								$(element).css("color","red");
								msg = "Multiply by " + multiplier;
								this.bindOpenTip(element, positionInFraction, msg);
							}
							else {		
								$(element).css("color","green");
							}
						}
						if(step == 2){
							//multiplier at this case only right input value (variables names correction must be done:TODO)
							switch (positionInFraction){
								case "numerator":
								if(value != multiplier && value !== "") {
									$(element).css("color","red");
									msg = "Must be " + multiplier;
									this.bindOpenTip(element, positionInFraction, msg);
								}
								else {		
									$(element).css("color","green");
								}
								break;
								case "denominator":
								if(value != this.commonDenominator && value !== "") {
									$(element).css("color","red");
									msg = "Common Denominator - " + this.commonDenominator;
									this.bindOpenTip(element, positionInFraction, msg);
								}
								else {		
									$(element).css("color","green");
								}
								break;
							}
						}
						if(step == 3){
							//multiplier at this case only right input value (variables names correction must be done:TODO)
							switch (positionInFraction){
								case "numerator":
								if(value != this.mult1 && value !== "") {
									$(element).css("color","red");
									msg = "Right answer " + this.mult1;
									this.bindOpenTip(element, positionInFraction, msg);
								}
								else {		
									$(element).css("color","green");
								}
								break;
								case "denominator":
								if(value != this.commonDenominator && value !== "") {
									$(element).css("color","red");
									msg = "Right answer " + this.commonDenominator;
									this.bindOpenTip(element, positionInFraction, msg);
								}
								else {		
									$(element).css("color","green");
								}
								break;
							}
						}
				},
				
				onBlurMult1: function (){
					this.validateNumberInput("numerator", 1);
				},
				
				onBlurMult2: function (){
					this.validateNumberInput("numerator", 2);			
				},

				onBlurMult3: function (){
					this.validateNumberInput("denominator", 1);
				},
				
				onBlurMult4: function (){
					this.validateNumberInput("denominator", 2);				
				}					
  });
 