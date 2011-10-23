package lib.ui.actions.changeparent {
	
	import lib.controllers.events.GraphEvent;
	import org.robotlegs.mvcs.Mediator;
	import com.krasimirtsonev.utils.Debug;
	
	public class ChangeParentMediator extends Mediator {
	
		[Inject] public var view:ChangeParentView;
		
		private function get className():String {
			return "ChangeParentMediator";
		}
		public override function onRegister():void {
			Debug.echo(className + " onRegister");
			eventMap.mapListener(view, GraphEvent.ACTION_CHANGE_PARENT, dispatch, GraphEvent);
		}
	
	}

}