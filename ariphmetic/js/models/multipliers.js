var Multipliers = Backbone.Model.extend({
	
	defaults: {
		multipliers:[]
	},
  
    initialize:function (options) {
		if(options) this.set({multipliers: options.multipliers});
    },

});