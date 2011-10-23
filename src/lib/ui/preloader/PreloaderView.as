package lib.ui.preloader {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import lib.ui.dot.DotView;
	
	public class PreloaderView extends MovieClip {
		
		private var _clip:DotView;
		private var _preloadText:String;
		private var _background:MovieClip;
		private var _backgroundColor:uint = 0xFFFFFF;
		
		public function PreloaderView() {
			_background = new MovieClip();
			_background.graphics.beginFill(_backgroundColor);
			_background.graphics.drawRect(0, 0, 1, 1);
			_background.graphics.endFill();
			addChild(_background);
			_clip = new DotView({title: "", color: "#3A3A3A"}, false);
			addChild(_clip);
		}
		public function onStageResize(newStageWidth:Number, newStageHeight:Number):void {
			_clip.x = newStageWidth / 2;
			_clip.y = newStageHeight / 2;
			_background.width = newStageWidth;
			_background.height = newStageHeight;
		}
		public function showPreloader(textParam:String):void {
			_preloadText = _clip.text = textParam;
			visible = true;
		}
		public function hidePreloader():void {
			visible = false;
		}
		
	}

}