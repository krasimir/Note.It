package lib.ui.actions.icon {
	
	import flash.display.MovieClip;
	import com.krasimirtsonev.utils.Debug;
	import flash.events.MouseEvent;
	import lib.controllers.events.GraphEvent;
	import com.krasimirtsonev.display.DisplayHelper;
	
	public class ActionIconView extends MovieClip {
		
		private var _clip:MovieClip;
		private var _action:String = "";
		private var _actionValue:String = "";
		private var _onClickEvents:Array;
		private var _deleteItemIndex:int = 0;
		
		public function ActionIconView(action:String, onClickEvents:Array = null, actionValue:String = ""):void {
			
			_action = action;
			_actionValue = actionValue;
			_onClickEvents = onClickEvents;
			_clip = new A_DotAction();
			_clip.back.gotoAndStop(1);
			_clip.mouseChildren = false;
			_clip.buttonMode = true;
			_clip.addEventListener(MouseEvent.MOUSE_OVER, onClipOver);
			_clip.addEventListener(MouseEvent.MOUSE_OUT, onClipOut);
			_clip.addEventListener(MouseEvent.CLICK, onClipClick);
			addChild(_clip);
			
			switch (_action) {
				case "expand":
					if(_actionValue == "no") {
						_clip.gotoAndStop("collapse");
					} else {
						_clip.gotoAndStop("expand");
					}
				break;
				default:
					_clip.gotoAndStop(_action);
				break;
			}
			
		}
		private function get className():String {
			return "ActionIconView";
		}
		private function onClipOver(e:MouseEvent):void {
			if(_action == "cancel") {
				_clip.back.gotoAndStop(3);	
			} else if(_action == "saveItem") {
				_clip.back.gotoAndStop(4);	
			} else {
				_clip.back.gotoAndStop(2);	
			}
			dispatchEvent(new GraphEvent(GraphEvent.ACTION_ICON_OVER));
		}
		private function onClipOut(e:MouseEvent):void {
			_clip.back.gotoAndStop(1);
			dispatchEvent(new GraphEvent(GraphEvent.ACTION_ICON_OUT));
			_deleteItemIndex = 0;
		}
		private function onClipClick(e:MouseEvent):void {
			switch (_action) {
				default:
					callEvents();
				break;
			}
		}
		private function callEvents():void {
			var numOfClickEvents:int = _onClickEvents ? _onClickEvents.length : 0;
			for(var i:int=0; i<numOfClickEvents; i++) {
				dispatchEvent(_onClickEvents[i]);
			}
		}
	
	}

}