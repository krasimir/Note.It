package lib.controllers.events {
	import flash.events.Event;
	
	public class GraphEvent extends Event {
		
		public static const SAVE_GRAPH:String = "_SAVE_GRAPH";
		public static const UPDATE_LINES:String = "_UPDATE_LINES";
		public static const GRAPH_POSITION_CHANGED:String = "_GRAPH_POSITION_CHANGED";
		public static const GRAPH_DOT_CLICKED:String = "_GRAPH_DOT_CLICKED";
		public static const SHOW_ACTIONS_HOLDER:String = "_SHOW_ACTIONS_HOLDER";
		public static const HIDE_ACTIONS_HOLDER:String = "_HIDE_ACTIONS_HOLDER";
		public static const ACTION_ICON_OVER:String = "_ACTION_ICON_OVER";
		public static const ACTION_ICON_OUT:String = "_ACTION_ICON_OUT";
		public static const ACTION_ICON_CLICK:String = "_ACTION_ICON_CLICK";
		public static const ACTION_CHANGE_PARENT:String = "_ACTION_CHANGE_PARENT";
		public static const REQUEST_FOR_NEW_GRAPH_ITEM:String = "_REQUEST_FOR_NEW_GRAPH_ITEM";
		public static const ADD_NEW_GRAPH_ITEM:String = "_ADD_NEW_GRAPH_ITEM";
		public static const DELETE_GRAPH_ITEM:String = "_DELETE_GRAPH_ITEM";
		public static const UPDATED_GRAPH_ITEMS_ARRAY:String = "_UPDATED_GRAPH_ITEMS_ARRAY";
		public static const SHOW_ITEM_TEXT_PAGE:String = "_SHOW_ITEM_TEXT_PAGE";
		public static const SAVE_ITEM:String = "_SAVE_ITEM";
		public static const CHANGE_EXPAND:String = "_CHANGE_EXPAND";
		public static const SHOW_CLOCK_PAGE:String = "_SHOW_CLOCK_PAGE";
		public static const START_CLOCK:String = "_START_CLOCK";
		public static const STOP_CLOCK:String = "_STOP_CLOCK";
		public static const GET_CLOCK_TIME:String = "_GET_CLOCK_TIME";
		public static const CLOCK_TIME_LOADED:String = "_CLOCK_TIME_LOADED";
		public static const CLOCK_TIME_LOADED_SET:String = "_CLOCK_TIME_LOADED_SET";
		public static const ADD_CLOCK_TIME:String = "_ADD_CLOCK_TIME";
		public static const REMOVE_CLOCK_TIME:String = "_REMOVE_CLOCK_TIME";
		public static const EDIT_CLOCK_TIME:String = "_EDIT_CLOCK_TIME";
		public static const SAVE_CLOCK_TIME:String = "_SAVE_CLOCK_TIME";
		public static const CLOCK_POMODORO:String = "_CLOCK_POMODORO";
		public static const CLOCK_INFO_WINDOW:String = "_CLOCK_INFO_WINDOW";
		
		private var _data:Object;
		
		public function GraphEvent(type:String, data:Object = null) {
			super(type);
			_data = data;
		}
		public function get data():Object {
			return _data;
		}
		public override function clone():Event {
			return new GraphEvent(type, _data);
		}
		
	}

}