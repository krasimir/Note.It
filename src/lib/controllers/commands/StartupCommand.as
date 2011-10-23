package lib.controllers.commands {
	
	import com.krasimirtsonev.data.helpers.Storage;
	import com.krasimirtsonev.utils.Delegate;
	import flash.display.MovieClip;
	import flash.events.Event;
	import lib.controllers.events.DataEvent;
	import lib.controllers.events.PreloaderEvent;
	import lib.controllers.events.StageResizeEvent;
	import lib.controllers.events.WorkspaceSelectingEvent;
	import lib.helpers.factories.FileSystemFactory;
	import lib.helpers.factories.XMLContentFactory;
	import lib.models.AppModel;
	import lib.models.vos.DirectoriesVO;
	import lib.services.data.DataLoaderService;
	import lib.core.IDataLoader;
	import lib.services.responders.ResponderXML;
	import lib.ui.pages.PagesHolderView;
	import lib.ui.preloader.PreloaderView;
	import lib.ui.workspace.WorkspaceSelectingView;
	import org.robotlegs.mvcs.Command;
	import com.krasimirtsonev.utils.Debug;
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	import com.krasimirtsonev.data.helpers.Session;
	
	public class StartupCommand extends Command {
		
		[Inject] public var appModel:AppModel;
		[Inject] public var dataLoaderService:IDataLoader;
		[Inject] public var fileSystemFactory:FileSystemFactory;
		[Inject] public var responderXML:ResponderXML;
		
		private var _preloaderView:PreloaderView;
		private var _pagesHolder:PagesHolderView;
		private var _workspaceSelecting:WorkspaceSelectingView;
		private var _workspaceDir:String = "";
		
		private function get className():String {
			return "StartupCommand";
		}
		override public function execute():void {
			Debug.echo(className + " execute");
			
			// pages holder
			_pagesHolder = new PagesHolderView();
			contextView.addChild(_pagesHolder);
			
			// preloader view
			_preloaderView = new PreloaderView();
			contextView.addChild(_preloaderView);
			eventDispatcher.dispatchEvent(new StageResizeEvent(StageResizeEvent.ON_APP_STAGE_RESIZE, appModel.appWidth, appModel.appHeight));
			eventDispatcher.dispatchEvent(new PreloaderEvent(PreloaderEvent.SHOW_PRELOADER, "YOUR WORKSPACE"));
			
			// initialize the app's files and directories
			preparingTheWorkspace();
			
		}
		private function preparingTheWorkspace():void {
			_workspaceSelecting = new WorkspaceSelectingView();
			_workspaceSelecting.addEventListener(WorkspaceSelectingEvent.ON_WORKSPACE_SELECTED, workspaceSet);
			contextView.addChild(_workspaceSelecting);
			_workspaceSelecting.show(appModel.appWidth, appModel.appHeight);
		}
		private function workspaceSet(e:WorkspaceSelectingEvent):void {	
			Debug.echo(className + " workspaceSet dir=" + _workspaceSelecting.dirPath);
			try {
				appModel.directories.data = fileSystemFactory.getDirectory(new File(_workspaceSelecting.dirPath), "data");
				appModel.directories.times = fileSystemFactory.getDirectory(appModel.directories.data, "times");
				appModel.config.file = fileSystemFactory.getFile(appModel.directories.data, "config.xml", XMLContentFactory.getConfigXML());
				appModel.log.file = fileSystemFactory.getFile(appModel.directories.data, "noteit.log", "");
				workspaceIsSet();
				contextView.removeChild(_workspaceSelecting);
			} catch(err:Error) {
				Debug.echo("workspaceSet error=" + err.message);
			}			
		}
		private function workspaceIsSet():void {
			dataLoaderService.readFile(appModel.config);
		}
		
	}

}