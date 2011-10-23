package lib.controllers.commands {
	
	import lib.controllers.events.GraphEvent;
	import lib.controllers.events.PagesEvent;
	import lib.core.IDataLoader;
	import lib.models.AppModel;
	import lib.models.vos.ClockVO;
	import lib.models.vos.FileVO;
	import lib.services.responders.ResponderXML;
	import lib.ui.dot.DotView;
	import lib.ui.pages.clock.PageClockView;
	import lib.ui.pages.items.PageTextItemView;
	import org.robotlegs.mvcs.Command;
	import com.krasimirtsonev.utils.Debug;
	import lib.helpers.factories.FileSystemFactory;
	import lib.helpers.factories.XMLContentFactory;
	
	public class GraphCommand extends Command {
		
		[Inject] public var event:GraphEvent;
		[Inject] public var appModel:AppModel;
		[Inject] public var dataLoaderService:IDataLoader;
		[Inject] public var fileSystemFactory:FileSystemFactory;
		[Inject] public var responderXML:ResponderXML;
		
		private function get className():String {
			return "GraphCommand";
		}
		public override function execute():void {
			Debug.echo(className + " execute type=" + event.type + " data=" + event.data);
			
			switch(event.type) {
				case GraphEvent.SAVE_GRAPH:
					if(event.data && event.data.x && event.data.y) {
						appModel.config.data.mainPageGraph.x = event.data.x;
						appModel.config.data.mainPageGraph.y = event.data.y;
					}
					appModel.config.updateContent();					
					dataLoaderService.writeFile(appModel.config);
				break;
				case GraphEvent.ACTION_CHANGE_PARENT:
					var child:DotView = event.data.child;
					var parent:DotView = event.data.parent;
					appModel.config.updateParent(child.id, parent.id);					
				break;
				case GraphEvent.REQUEST_FOR_NEW_GRAPH_ITEM:
					dispatch(new GraphEvent(GraphEvent.ADD_NEW_GRAPH_ITEM, appModel.config.addNewGraphItem()));
				break;
				case GraphEvent.DELETE_GRAPH_ITEM:
					appModel.config.deleteItem(event.data as String);
					dispatch(new GraphEvent(GraphEvent.UPDATED_GRAPH_ITEMS_ARRAY));
				break;
				case GraphEvent.SHOW_ITEM_TEXT_PAGE:
					var data:Object = appModel.config.getItem(event.data.id as String);
					data.isNewItem = event.data.isNewItem;
					if(data) {
						dispatch(new PagesEvent(PagesEvent.SHOW_PAGE_TEXT_ITEM, data));
					}
				break;
				case GraphEvent.SHOW_CLOCK_PAGE:
					data = appModel.config.getItem(event.data.id as String);
					data.autoStart = event.data.autoStart;
					if(data) {
						dispatch(new PagesEvent(PagesEvent.SHOW_PAGE_CLOCK, data));
					}
				break;
				case GraphEvent.CHANGE_EXPAND:
					appModel.config.changeExpand(event.data as String);
				break;
				case GraphEvent.GET_CLOCK_TIME:
					appModel.clock.file = fileSystemFactory.getFile(appModel.directories.times, "time_" + event.data + ".xml", XMLContentFactory.getTimeDefaultXML());
					dataLoaderService.readFile(appModel.clock);
				break;
				case GraphEvent.CLOCK_TIME_LOADED:
					appModel.clock.updateTimesArray();
					dispatch(new GraphEvent(GraphEvent.CLOCK_TIME_LOADED_SET));
				break;
				case GraphEvent.ADD_CLOCK_TIME:
					appModel.clock.addTime(event.data);
				break;
				case GraphEvent.REMOVE_CLOCK_TIME:
					appModel.clock.removeTime(event.data);
				break;
				case GraphEvent.EDIT_CLOCK_TIME:
					appModel.clock.editTime(event.data);
				break;
				case GraphEvent.SAVE_CLOCK_TIME:
					appModel.clock.updateContent();
					dataLoaderService.writeFile(appModel.clock);
				break;
			}
			
		}
		
	}

}