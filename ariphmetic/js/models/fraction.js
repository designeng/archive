var Fraction = Backbone.Model.extend({
	
	defaults: {
		fractionStr: "",
		numerator:  0,
		denominator:  0
	},
  
    initialize:function (options) {
		var f = $.trim(options.fractionStr);
        if(f !== "" && this.validateInitialFraction(f)){
			var res = this.parseFractionStr(f);
			this.attributes.numerator = Number(res[0]);
			this.attributes.denominator = Number(res[1]);
			this.attributes.fractionStr = f;
		} else {
			dispatcher.trigger('error:validation', {msg: "Something's wrong!"});
		}
    },
	
	//some initial task validations...
	  validateInitialFraction: function (fractionStr){
		var fractionSign = /((\d*)\/(\d*))/g;
		var intRegex = /^\d+$/;
		var f = $.trim(fractionStr);
		if ( !f.match(fractionSign)) {
				return false;
		} else if(this.divisionByZero(f)){
				//throw new Error("Division by zero: " + f);
				dispatcher.trigger('error:by zero');
				return false;
		}
		dispatcher.trigger('no errors');
		return true;
	  },
	  
	  divisionByZero: function (f){
		var arr = f.split("/");
		if (Number(arr[1]) === 0) return true;
		else return false;
	  },
	  
	  parseFractionStr: function (f){
		var arr = ($.trim(f)).split("/");
		return arr;
	  },

});