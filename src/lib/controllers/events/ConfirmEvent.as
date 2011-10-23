package lib.controllers.events {
	
	import flash.events.Event;
		
	public class ConfirmEvent extends Event {
			
		public static const CONFIRM:String = "_CONFIRM";
		public static const YES:String = "_YES";
		public static const NO:String = "_NO";
		
		private var _data:Object;
			
		public function ConfirmEvent(type:String, data:Object = null) {
			super(type);
			_data = data;
		}
		public function get data():Object {
			return _data;
		}
		public override function clone():Event {
			return new ConfirmEvent(type, _data);
		}
			
	}

}