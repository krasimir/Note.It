package lib.contexts {
	
	import com.krasimirtsonev.utils.Debug;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import lib.controllers.commands.DataLoadedCommand;
	import lib.controllers.commands.GraphCommand;
	import lib.controllers.commands.LogCommand;
	import lib.controllers.commands.StartupCommand;
	import lib.controllers.events.DataEvent;
	import lib.controllers.events.GraphEvent;
	import lib.controllers.events.StageResizeEvent;
	import lib.controllers.events.SystemTrayEvent;
	import lib.core.IDataLoader;
	import lib.helpers.factories.FileSystemFactory;
	import lib.helpers.SystemTray;
	import lib.models.AppModel;
	import lib.services.data.DataLoaderService;
	import lib.services.responders.ResponderXML;
	import lib.ui.actions.ActionsHolderMediator;
	import lib.ui.actions.ActionsHolderView;
	import lib.ui.actions.changeparent.ChangeParentMediator;
	import lib.ui.actions.changeparent.ChangeParentView;
	import lib.ui.actions.icon.ActionIconMediator;
	import lib.ui.actions.icon.ActionIconView;
	import lib.ui.confirm.ConfirmMediator;
	import lib.ui.confirm.ConfirmView;
	import lib.ui.dot.DotMediator;
	import lib.ui.dot.DotView;
	import lib.ui.pages.clock.PageClockMediator;
	import lib.ui.pages.clock.PageClockNavMediator;
	import lib.ui.pages.clock.PageClockNavView;
	import lib.ui.pages.clock.PageClockView;
	import lib.ui.pages.graph.PageGraphMediator;
	import lib.ui.pages.graph.PageGraphView;
	import lib.ui.pages.items.PageTextItemMediator;
	import lib.ui.pages.items.PageTextItemNavMediator;
	import lib.ui.pages.items.PageTextItemNavView;
	import lib.ui.pages.items.PageTextItemView;
	import lib.ui.pages.PagesHolderMediator;
	import lib.ui.pages.PagesHolderView;
	import lib.ui.preloader.PreloaderMediator;
	import lib.ui.preloader.PreloaderView;
	import lib.ui.workspace.WorkspaceSelectingMediator;
	import lib.ui.workspace.WorkspaceSelectingView;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	public class NoteItContext extends Context {
		
		private var _appModel:AppModel;
		private var _systemTray:SystemTray;
		
		public function NoteItContext(view:DisplayObjectContainer) {
			super(view);
		}
		public function get appModel():AppModel {
			return _appModel;
		}
		private function get className():String {
			return "NoteItContext";
		}
		override public function startup():void {
			Debug.echo(className + " startup");
			
			// mapping
			commandMap.mapEvent(ContextEvent.STARTUP, StartupCommand, ContextEvent);
			commandMap.mapEvent(DataEvent.ON_DATA_LOADED, DataLoadedCommand, DataEvent);
			commandMap.mapEvent(GraphEvent.SAVE_GRAPH, GraphCommand, GraphEvent);
			commandMap.mapEvent(GraphEvent.ACTION_CHANGE_PARENT, GraphCommand, GraphEvent);
			commandMap.mapEvent(GraphEvent.REQUEST_FOR_NEW_GRAPH_ITEM, GraphCommand, GraphEvent);
			commandMap.mapEvent(GraphEvent.DELETE_GRAPH_ITEM, GraphCommand, GraphEvent);
			commandMap.mapEvent(GraphEvent.CHANGE_EXPAND, GraphCommand, GraphEvent);
			commandMap.mapEvent(GraphEvent.SHOW_ITEM_TEXT_PAGE, GraphCommand, GraphEvent);
			commandMap.mapEvent(GraphEvent.SHOW_CLOCK_PAGE, GraphCommand, GraphEvent);
			commandMap.mapEvent(GraphEvent.ADD_CLOCK_TIME, GraphCommand, GraphEvent);
			commandMap.mapEvent(GraphEvent.GET_CLOCK_TIME, GraphCommand, GraphEvent);
			commandMap.mapEvent(GraphEvent.SAVE_CLOCK_TIME, GraphCommand, GraphEvent);
			commandMap.mapEvent(GraphEvent.CLOCK_TIME_LOADED, GraphCommand, GraphEvent);
			commandMap.mapEvent(GraphEvent.EDIT_CLOCK_TIME, GraphCommand, GraphEvent);
			commandMap.mapEvent(GraphEvent.REMOVE_CLOCK_TIME, GraphCommand, GraphEvent);
			mediatorMap.mapView(PreloaderView, PreloaderMediator);
			mediatorMap.mapView(DotView, DotMediator);
			mediatorMap.mapView(PagesHolderView, PagesHolderMediator);
			mediatorMap.mapView(PageGraphView, PageGraphMediator);
			mediatorMap.mapView(ActionIconView, ActionIconMediator);
			mediatorMap.mapView(ActionsHolderView, ActionsHolderMediator);
			mediatorMap.mapView(ChangeParentView, ChangeParentMediator);
			mediatorMap.mapView(PageTextItemView, PageTextItemMediator);
			mediatorMap.mapView(PageClockView, PageClockMediator);
			mediatorMap.mapView(ConfirmView, ConfirmMediator);
			mediatorMap.mapView(PageTextItemNavView, PageTextItemNavMediator);
			mediatorMap.mapView(PageClockNavView, PageClockNavMediator);
			mediatorMap.mapView(WorkspaceSelectingView, WorkspaceSelectingMediator);
			injector.mapSingleton(AppModel);
			injector.mapSingleton(FileSystemFactory);
			injector.mapSingleton(ResponderXML);
			injector.mapClass(IDataLoader, DataLoaderService);
			
			// creating the app model
			_appModel = injector.getInstance(AppModel);
			
			// init system tray
			_systemTray = new SystemTray(contextView, this);
			_systemTray.addEventListener(SystemTrayEvent.OPEN_FROM_TRAY, openFromSystemTray);
			
			// setting stage resize listeners
			_contextView.stage.addEventListener(Event.RESIZE, onStageResize);
			
			// calling the startup command	
			commandMap.execute(StartupCommand);
			
		}
		public function onAppClose():void {
			commandMap.execute(LogCommand);
		}
		// stage resizing
		private function onStageResize(e:Event = null):void {
			_appModel.appWidth = _contextView.stage.stageWidth;
			_appModel.appHeight = _contextView.stage.stageHeight;
			dispatchEvent(new StageResizeEvent(StageResizeEvent.ON_APP_STAGE_RESIZE, _appModel.appWidth, _appModel.appHeight));
		}
		// open from system tray
		private function openFromSystemTray(e:SystemTrayEvent):void {
			dispatchEvent(e);
		}
		
	}

}