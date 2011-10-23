package lib.ui.confirm {
	
	import com.krasimirtsonev.managers.tween.TweenManager;
	import flash.display.MovieClip;
	import com.krasimirtsonev.utils.Debug;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import lib.controllers.events.ConfirmEvent;
	
	public class ConfirmView extends MovieClip {
		
		private var _data:Object;
		private var _over:MovieClip;
		private var _nav:ConfirmNavView;
		private var _clip:MovieClip;
		
		public function ConfirmView(data:Object):void {
			
			_data = data;
			
			_over = new MovieClip();
			_over.graphics.beginFill(0x000000, 0.9);
			_over.graphics.drawRect(0, 0, 10, 10);
			_over.graphics.endFill();
			addChild(_over);
			
			_nav = new ConfirmNavView();
			addChild(_nav);
			
			_clip = new A_ConfirmClip();
			_clip.field.autoSize = TextFieldAutoSize.CENTER;
			_clip.field.htmlText = '<font size="50">' + (_data.label ? _data.label : "Are you sure?") + '</font>';
			addChild(_clip);
			
			TweenManager.alpha(_over, 0, 1, 0, 10);
			
		}
		public function updateVisuals(appWidth:Number, appHeight:Number):void {
			_over.width = appWidth;
			_over.height = appHeight;
			_clip.field.x = (appWidth - _clip.field.width) / 2;
			_clip.field.y = ((appHeight - _clip.field.height) / 2) - 50;
			_nav.x = (appWidth - _nav.width) / 2;
			_nav.y = ((appHeight - _nav.height) / 2) + 30;
		}
		public function yes(e:ConfirmEvent):void {
			if(_data.callback) {
				_data.callback();
			}
		}
		private function get className():String {
			return "ConfirmView";
		}
	
	}

}