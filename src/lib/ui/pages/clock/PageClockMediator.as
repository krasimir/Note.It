package lib.ui.pages.clock {
	
	import lib.controllers.events.ConfirmEvent;
	import lib.controllers.events.StageResizeEvent;
	import lib.models.AppModel;
	import org.robotlegs.mvcs.Mediator;
	import com.krasimirtsonev.utils.Debug;
	import lib.controllers.events.GraphEvent;
	
	public class PageClockMediator extends Mediator {
	
		[Inject] public var view:PageClockView;
		[Inject] public var appModel:AppModel;
		
		private function get className():String {
			return "PageClockMediator";
		}
		public override function onRegister():void {
			Debug.echo(className + " onRegister");
			eventMap.mapListener(eventDispatcher, GraphEvent.START_CLOCK, view.startClock, GraphEvent);
			eventMap.mapListener(eventDispatcher, GraphEvent.STOP_CLOCK, view.stopClock, GraphEvent);
			eventMap.mapListener(eventDispatcher, GraphEvent.CLOCK_POMODORO, view.changePomodoroMode, GraphEvent);
			eventMap.mapListener(eventDispatcher, GraphEvent.CLOCK_INFO_WINDOW, view.changeClockInfoMode, GraphEvent);
			eventMap.mapListener(eventDispatcher, GraphEvent.CLOCK_TIME_LOADED_SET, clockTimeLoadedSet, GraphEvent);
			eventMap.mapListener(eventDispatcher, StageResizeEvent.ON_APP_STAGE_RESIZE, onStageResize, StageResizeEvent);
			eventMap.mapListener(view, GraphEvent.ADD_CLOCK_TIME, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.EDIT_CLOCK_TIME, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.REMOVE_CLOCK_TIME, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.SAVE_GRAPH, dispatch, GraphEvent);
			eventMap.mapListener(view, GraphEvent.SAVE_CLOCK_TIME, dispatch, GraphEvent);
			eventMap.mapListener(view, ConfirmEvent.CONFIRM, dispatch, ConfirmEvent);
			onStageResize();
			dispatch(new GraphEvent(GraphEvent.GET_CLOCK_TIME, view.id));
		}
		private function onStageResize(e:StageResizeEvent = null):void {
			view.updateVisuals(appModel.appWidth, appModel.appHeight);
		}
		private function clockTimeLoadedSet(e:GraphEvent):void {
			view.clockTimesLoaded(appModel.clock.times);
		}
	
	}

}