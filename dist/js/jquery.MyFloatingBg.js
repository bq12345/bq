(function($) {

	var _options = new Array();
	jQuery.fn.MyFloatingBg = function(options) {
		//extend options
		_options[_options.length] = $.extend({}, $.fn.MyFloatingBg.defaults,
			options);
		var direction = _options[0].direction;

		var sign1 = "+";
		var sign2 = "+";
		if (direction == 0) {
			sign1 = "+";
			sign2 = "-";
		} else if (direction == 1) {
			sign1 = "-";
			sign2 = "+";
		} else if (direction == 2) {
			sign1 = "+";
			sign2 = "+";
		} else if (direction == 3) {
			sign1 = "-";
			sign2 = "-";
		}

		$(this).each(function() {
			var bg = $(this).attr("bg");
			$(this).css("background", "url('" + bg + "')");
			$(this).attr("sign1", sign1);
			$(this).attr("sign2", sign2);
			$(this).attr("cnt", 1);
			doShift($(this));
		});
	}

	function doShift(o) {
		setTimeout(function() {
			var cnt = $(o).attr("cnt");

			if (cnt > 1000)
			cnt = 0;
			else{
				cnt = eval(cnt) + 1;
			}
		$(o).attr("cnt", cnt);
		var sign1 = $(o).attr("sign1");
		var sign2 = $(o).attr("sign2");
		o.css("backgroundPosition", sign1 + cnt + "px" + " " + sign2 + cnt
			+ "px");
		doShift(o);
		}, _options[0].speed);
	}
	//方向1 2 3 4
	function getDirection() {
		return Math.floor(Math.random() * 4)
	}

	jQuery.fn.MyFloatingBg.defaults = {
		speed : 50,
		direction : 2
	};
})(jQuery);
