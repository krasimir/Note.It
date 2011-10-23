package lib.models.vos {
	
	import lib.helpers.factories.XMLContentFactory;
	import lib.helpers.DateFormater;
	import com.krasimirtsonev.utils.Debug;
	
	public class ClockVO extends FileVO {
		
		public var times:Array;
		
		public function ClockVO() {
			key = "_CLOCK";
		}
		public override function updateContent():void {
			content = '';
			content += '<xml>';
			content += '<times>';
			var numOfTimes:int = times.length;
			for(var i:int=0; i<numOfTimes; i++) {
				content += XMLContentFactory.getTimeXMLFromObject(times[i]);
			}
			content += '</times>';
			content += '</xml>';
		}
		public function updateTimesArray():void {
			if(
				data.times && 
				data.times != "string" && 
				data.times.time && 
				typeof data.times.time != "string" && 
				data.times.time.length > 0
			) {
				times = data.times.time;
			} else {
				times = [];
			}
		}
		public function addTime(obj:Object):void {
			var time:Object = {
				start: DateFormater.date2Str(obj.start),
				end: DateFormater.date2Str(obj.end),
				hours: obj.hours,
				mins: obj.minutes,
				desc: obj.desc ? obj.desc : ""
			};
			if(times != null && (obj.hours > 0 || obj.minutes > 0)) {
				times.push(time);
			}
		}
		public function removeTime(obj:Object):void {
			var numOfTimes:int = times.length;
			for(var i:int=0; i<numOfTimes; i++) {
				if(obj == times[i]) {
					times.splice(i, 1)
					return;
				}
			}
		}
		public function editTime(obj:Object):void {
			
		}
		
	}

}