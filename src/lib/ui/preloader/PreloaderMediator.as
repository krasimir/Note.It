package lib.ui.preloader {
	
	import lib.controllers.events.PreloaderEvent;
	import lib.controllers.events.StageResizeEvent;
	import org.robotlegs.mvcs.Mediator;
	import com.krasimirtsonev.utils.Debug;
	
	public class PreloaderMediator extends Mediator {
		
		[Inject] public var view:PreloaderView;
		
		private function get className():String {
			return "PreloaderMediator";
		}
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher, PreloaderEvent.SHOW_PRELOADER, onShowPreloader, PreloaderEvent);
			eventMap.mapListener(eventDispatcher, PreloaderEvent.HIDE_PRELOADER, onHidePreloader, PreloaderEvent);
			eventMap.mapListener(eventDispatcher, StageResizeEvent.ON_APP_STAGE_RESIZE, onStageResize, StageResizeEvent);
		}
		private function onShowPreloader(e:PreloaderEvent):void {
			view.showPreloader(e.text);
		}
		private function onHidePreloader(e:PreloaderEvent):void {
			view.hidePreloader();
		}
		private function onStageResize(e:StageResizeEvent):void {
			view.onStageResize(e.appWidth, e.appHeight);
		}
		
	}

}