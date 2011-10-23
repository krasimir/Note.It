package lib.controllers.events {
	
	import flash.events.Event;
	
	public class DataEvent extends Event {
		
		public static var ON_DATA_LOADED:String = "_ON_DATA_LOADED";
		
		private var _data:Object;
		private var _key:String;
		
		public function DataEvent(type:String, data:Object = null, key:String = "") {
			super(type);
			_data = data;
			_key = key;
		}
		public function get data():Object {
			return _data;
		}
		public function get key():String {
			return _key;
		}
		public override function clone():Event {
			return new DataEvent(type, _data, _key);
		}
		
	}

}