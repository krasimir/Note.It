package lib.ui.actions {
	
	import lib.controllers.events.GraphEvent;
	import org.robotlegs.mvcs.Mediator;
	import com.krasimirtsonev.utils.Debug;
	
	public class ActionsHolderMediator extends Mediator {
		
		[Inject] public var view:ActionsHolderView;
		
		private function get className():String {
			return "ActionsHolderMediator";
		}
		public override function onRegister():void {
			Debug.echo(className + " onRegister");
			eventMap.mapListener(eventDispatcher, GraphEvent.SHOW_ACTIONS_HOLDER, view.show, GraphEvent);
			eventMap.mapListener(eventDispatcher, GraphEvent.HIDE_ACTIONS_HOLDER, view.hide, GraphEvent);
			eventMap.mapListener(view, GraphEvent.ACTION_ICON_CLICK, dispatch, GraphEvent);
		}
	
	}

}