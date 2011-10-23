package lib.controllers.events {
	import flash.events.Event;
	
	public class PreloaderEvent extends Event {
		
		public static const SHOW_PRELOADER:String = "_SHOW_PRELOADER";
		public static const HIDE_PRELOADER:String = "_HIDE_PRELOADER";
		
		private var _text:String = "";
		
		public function PreloaderEvent(type:String, text:String = "") {
			super(type);
			_text = text;
		}
		public function get text():String {
			return _text;
		}
		override public function clone():Event {
			return new PreloaderEvent(type, _text);
		}
		
	}

}