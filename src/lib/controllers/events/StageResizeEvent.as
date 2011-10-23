package lib.controllers.events {
	
	import flash.events.Event;
	
	public class StageResizeEvent extends Event {
		
		public static const ON_APP_STAGE_RESIZE:String = "_ON_APP_STAGE_RESIZE";
		
		private var _appWidth:Number = 0;
		private var _appHeight:Number = 0;
		
		public function StageResizeEvent(type:String, appWidth:Number = 0, appHeight:Number = 0) { 
			super(type);
			_appWidth = appWidth;
			_appHeight = appHeight;
		} 
		public override function clone():Event { 
			return new StageResizeEvent(type, _appWidth, _appHeight);
		} 
		public function get appWidth():Number {
			return _appWidth;
		}
		public function get appHeight():Number {
			return _appHeight;
		}
	}
	
}