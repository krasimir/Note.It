package lib.ui.confirm {
	
	import lib.controllers.events.StageResizeEvent;
	import lib.models.AppModel;
	import org.robotlegs.mvcs.Mediator;
	import com.krasimirtsonev.utils.Debug;
	import lib.controllers.events.ConfirmEvent;
	
	public class ConfirmMediator extends Mediator {
	
		[Inject] public var view:ConfirmView;
		[Inject] public var appModel:AppModel;
		
		private function get className():String {
			return "ConfirmMediator";
		}
		public override function onRegister():void {
			Debug.echo(className + " onRegister");
			eventMap.mapListener(eventDispatcher, StageResizeEvent.ON_APP_STAGE_RESIZE, onStageResize, StageResizeEvent);	
			eventMap.mapListener(eventDispatcher, ConfirmEvent.YES, view.yes, ConfirmEvent);
			onStageResize();
		}
		private function onStageResize(e:StageResizeEvent = null):void {
			view.updateVisuals(appModel.appWidth, appModel.appHeight);
		}
	
	}

}