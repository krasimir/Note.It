package lib.ui.workspace {
	
	import org.robotlegs.mvcs.Mediator;
	import com.krasimirtsonev.utils.Debug;
	import lib.controllers.events.StageResizeEvent;
	
	public class WorkspaceSelectingMediator extends Mediator {
	
		[Inject] public var view:WorkspaceSelectingView;
		
		private function get className():String {
			return "WorkspaceSelectingMediator";
		}
		public override function onRegister():void {
			Debug.echo(className + " onRegister");
			
			eventMap.mapListener(eventDispatcher, StageResizeEvent.ON_APP_STAGE_RESIZE, onStageResize, StageResizeEvent);
	
		}
		private function onStageResize(e:StageResizeEvent):void {
			view.onStageResize(e.appWidth, e.appHeight);
		}
	
	}

}