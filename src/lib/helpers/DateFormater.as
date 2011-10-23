package lib.helpers {
	
	public class DateFormater {
		
		public static function get nowAsStr():String {
			return date2Str(new Date());
		}
		public static function get nowAsObj():Date {
			return new Date();
		}
		public static function date2Str(date:Date):String {
			return date.date + "-" + date.month + "-" + date.fullYear + " " + date.hours + ":" + date.minutes;
		}
		public static function str2Date(str:String):Date {
			var tmp1:Array = str.split(" ");
			var tmp2:Array = tmp1[0].split("-");
			var tmp3:Array = tmp1[1].split(":");
			return new Date(tmp2[2], tmp2[1], tmp2[0], tmp3[0], tmp3[1]);
		}
		public static function date2Label(date:String, hideTime:Boolean = false):String {
			var d:Date = str2Date(date);
			var monthNames:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
			var str:String = d.date + " " + monthNames[d.month] + " " + d.fullYear;
			if(!hideTime) {
				str += " " + d.hours + ":" + d.minutes;
			}
			return str;
		}
		
	}

}