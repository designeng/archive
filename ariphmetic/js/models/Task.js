var Task = Backbone.Model.extend({
	
	fTask: undefined,
	
	commonDenominator:1,	
	
	defaults: {
		fractions: [new Fraction({fractionStr:"1/4"}), new Fraction({fractionStr:"3/7"})],
		step:undefined,
		operationSign: "+",
		mult1: undefined,
		mult2: undefined,
		mult3: undefined,
		mult4: undefined		
	},
  
    initialize:function (options) {
		if (options)	{
			this.set({fractions: options.fractions});
			this.set({step: options.step});
		}
		this.fTask = new FractionsTask();
		for(var i = 0, l = this.get("fractions").length, arr = this.get("fractions"); i < l; i++){
			this.fTask.add(arr[i]);
		}
		var denominatorRange = this.fTask.pluck("denominator");
		this.set({commonDenominator: this.multiply(denominatorRange)});
		for(var i = 0, l = denominatorRange.length; i < l; i++){
			var key = "mult" + (i + 1);
			var key2 = "mult" + (i + 1 + 2);
			this.attributes[key] = this.attributes[key2] = "" + this.get("commonDenominator")/denominatorRange[i];
		}		
    },

	multiply: function(arr){
		var m = 1;
		for(var i = 0, l = arr.length; i < l; i++){
			m = m * arr[i];
		}
		return m;
	}

});