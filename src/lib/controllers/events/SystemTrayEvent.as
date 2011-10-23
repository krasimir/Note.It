package lib.controllers.events {
	
	import flash.events.Event;
		
	public class SystemTrayEvent extends Event {
			
		public static const OPEN_FROM_TRAY:String = "_OPEN_FROM_TRAY";
			
		public function SystemTrayEvent(type:String) {
			super(type);
		}
		public override function clone():Event {
			return new SystemTrayEvent(type);
		}
			
	}

}