package lib.controllers.events {
	
	import flash.events.Event;
	import lib.core.IPage;
	
	public class PagesEvent extends Event {
		
		public static const SHOW_PAGE:String = "_SHOW_PAGE";
		public static const SHOW_PAGE_GRAPH:String = "_SHOW_PAGE_GRAPH";
		public static const SHOW_PAGE_TEXT_ITEM:String = "_SHOW_PAGE_TEXT_ITEM";
		public static const SHOW_PAGE_CLOCK:String = "_SHOW_PAGE_CLOCK";
		
		private var _data:*;
		
		public function PagesEvent(type:String, data:* = null) {
			super(type);
			_data = data;
		}
		public function get data():* {
			return _data;
		}
		public override function clone():Event {
			return new PagesEvent(type, _data);
		}
		
	}

}