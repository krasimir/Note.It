package lib.controllers.events {
	
	import flash.events.Event;
		
	public class WorkspaceSelectingEvent extends Event {
			
		public static const ON_WORKSPACE_SELECTED:String = "_ON_WORKSPACE_SELECTED";
			
		public function WorkspaceSelectingEvent(type:String) {
			super(type);
		}
		public override function clone():Event {
			return new WorkspaceSelectingEvent(type);
		}
			
	}

}