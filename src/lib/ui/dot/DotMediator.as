package lib.ui.dot {
	
	import lib.controllers.events.GraphEvent;
	import org.robotlegs.mvcs.Mediator;
	import com.krasimirtsonev.utils.Debug;
	
	public class DotMediator extends Mediator {
		
		[Inject] public var view:DotView;
		
		private function get className():String {
			return "DotMediator";
		}
		override public function onRegister():void {
			view.addEventListener(GraphEvent.SHOW_ACTIONS_HOLDER, dispatch);
			view.addEventListener(GraphEvent.HIDE_ACTIONS_HOLDER, dispatch);
			view.addEventListener(GraphEvent.ACTION_ICON_CLICK, dispatch);
		}
		
	}

}