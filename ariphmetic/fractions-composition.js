var FractionComposition = function(){  
  var fractions = [];
  var sign;
  var taskContent = "";
  var step = 0;
  var element = "fractions-composition-wrapper";  
  var devisionSign = "/";
  //object to accumulate errors in composition fractions positions
  var fractionErrors = {
	n1: 0, n2: 0, d1: 0, d2: 0
  };
  
  
    
  //validation inside
  function setCompositionFractions(expression, sign){
	this.sign = sign;
	if(typeof expression != "string") {
		return false;
	} else {
		var fractions = [];
		fractions = expression.split(sign, 2);
		var res = validateInitialFractions(fractions);
		r = (res == true) ? true : false;
		if(r) {
			//prepare fractions data for both steps (0, 1)
			this.fractions[0] = this.fractions[1] = this.fractions[2] = valuesPreparation(fractions);
		}
		return r;
	}
  }
  
  function valuesPreparation(arr){
	for(var i = 0, l = arr.length; i < l; i++){
		arr[i] = ($.trim(arr[i])).split(devisionSign);
	}
	return arr;
  }
  
  function getCompositionFractions(){
	return this.fractions;
  }
  
  //some initial task validations...
  function validateInitialFractions(fractions){
	var f = fractions;
	var length = f.length;
	var fractionSign = /((\d*)\/(\d*))/g;
	var intRegex = /^\d+$/;
	for(var i = 0; i < length; i++){
		console.log(i, f[i]);
		var member = $.trim(f[i]);
		if ( !member.match(fractionSign)) {
			return false;
		} else if(divisionByZero(member)){
			throw new Error("Division by zero: " + member);
		}
	}
	return true;
  }
  
  function divisionByZero(f){
	var arr = f.split("/");
	if (Number(arr[1]) == 0) return true;
	else return false;
  }
  
  function isInt(value) { 
		return !isNaN(parseInt(value,10)) && (parseFloat(value,10) == parseInt(value,10)); 
  }
  
  function stepIncrease(){
		this.step++;
  }
  
  function getStep(){
		return step;
  }
  
  function nextStep(){
		return getStep() + 1;
  }
  
  function stepComplete(step){
		if(!$("#numerator-" + step + "-1").val() || !$("#denominator-" + step + "-1").val() || !$("#numerator-" + step + "-2").val() || !$("#denominator-" + step + "-2").val()) return false;
		for(var i in fractionErrors){
			console.log(i, fractionErrors[i]);
			if(fractionErrors[i] == 1) return false;
		}
		return true;
  }
  
  function validateNumerator(positionInFraction, value, indexInOperation, step){
		//inversion: numerator-[step]-1 must be multiplied by denominator-[step]-2 value
		var char0 = positionInFraction.charAt(0);
		var i = (indexInOperation == 1) ? 1 : 0;
		var multiplier = fractions[step][i][1];
		if(value != multiplier) {
			fractionErrors[char0 + indexInOperation] = 1;
			$("#" + positionInFraction + "-" + step + "-" + indexInOperation).css("color","red");
		}
		else {
			fractionErrors[char0 + indexInOperation] = 0;				
			$("#" + positionInFraction + "-" + step + "-" + indexInOperation).css("color","green");
			if(stepComplete(step)) {
				inputFreeze(step);
				window.FractionComposition.display(2);
			}
		}
  }
  //не работает
  function inputFreeze(step){
		$("#numerator-" + step + "-1").attr('disabled','disabled');  
		$("#denominator-" + step + "-1").attr('disabled','disabled');  
		$("#numerator-" + step + "-2").attr('disabled','disabled');  
		$("#denominator-" + step + "-2").attr('disabled','disabled');  
  }
  
  function bindListeners(step){
				//var step = nextStep();
				$("#numerator-" + step + "-1").bind("blur", function(){
					validateNumerator("numerator", $(this).val(), 1, step);
				});
				$("#denominator-" + step + "-1").bind("blur", function(){
					validateNumerator("denominator", $(this).val(), 1, step);
				});
				$("#numerator-" + step + "-2").bind("blur", function(){
					validateNumerator("numerator", $(this).val(), 2, step);
				});
				$("#denominator-" + step + "-2").bind("blur", function(){
					validateNumerator("denominator", $(this).val(), 2, step);
				});
  }
  
  function display(step){
	console.log("-----------------------");
	if(step == 0 && this.fractions[step].length < 2) throw new Error("Needed tow members at least!");
	var compiledTemplate = Handlebars.getTemplate('fractions-composition');
	console.log("step:", step);
	console.log("fractions", this.fractions);
	if(this.fractions){
		var stepContent = compiledTemplate({step:step,
				operationSign: this.sign,
				equialSign: "=",
				leftFractionNumerator: this.fractions[step][0][0],
				leftFractionDenominator: this.fractions[step][0][1],
				rightFractionNumerator: this.fractions[step][1][0],
				rightFractionDenominator: this.fractions[step][1][1]
			});
	}
	//alert(stepContent);
	this.taskContent += stepContent;
	$("#" + this.element).html(this.taskContent);
	bindListeners(step);
  }
  
  return {
	element:element,
	step: step,
	stepIncrease: stepIncrease,	
	fractions: fractions,
	taskContent: taskContent,
	display: display,
	setCompositionFractions: setCompositionFractions,
	getCompositionFractions: getCompositionFractions
  }
}();