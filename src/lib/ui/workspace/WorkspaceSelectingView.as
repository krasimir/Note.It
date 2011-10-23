package lib.ui.workspace {
	
	import flash.display.MovieClip;
	import com.krasimirtsonev.utils.Debug;
	import com.krasimirtsonev.data.helpers.Session;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.filesystem.File;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	import lib.controllers.events.WorkspaceSelectingEvent;
	
	public class WorkspaceSelectingView extends MovieClip {
		
		private var _dirPath:String;
		private var _clip:MovieClip;
		private var _isSet:Boolean = false;
		private var _text:String = "";
		private var _file:File;
		
		public function WorkspaceSelectingView():void {
			_dirPath = Session.getSession("workspaceDir");
			_isSet = _dirPath ? true : false;
		}
		public function get dirPath():String {
			return _dirPath;
		}
		public function show(appWidth:Number, appHeight:Number):void {
			Debug.echo(className + " show _isSet=" + _isSet + " appWidth=" + appWidth + " appHeight=" + appHeight);
			x = appWidth / 2;
			y = (appHeight / 2) + 10;
			_clip = new A_WorkspaceSelecting();
			_clip.field.autoSize = TextFieldAutoSize.LEFT;
			_clip.field.width = 300;
			_clip.field.x = - _clip.field.width / 2;
			_clip.field.styleSheet = getStyleSheet();
			_clip.field.addEventListener(TextEvent.LINK, onTextLinkClick);
			if(!_isSet) {
				_text += "There is no selected workspace.<br />";
				_text += "<a href='event:select'>Select</a>";
			} else {
				_text += "Your current workspace is:<br />";
				_text += _dirPath + "<br />";
				_text += "<a href='event:change'>Change workspace</a> or ";
				_text += "<a href='event:use'>continue.</a>";
			}
			_clip.field.htmlText = _text;
			addChild(_clip);
		}
		public function onStageResize(appWidth:Number, appHeight:Number):void {
			x = appWidth / 2;
			y = (appHeight / 2) + 10;
		}
		private function get className():String {
			return "WorkspaceSelectingView";
		}
		private function getStyleSheet():StyleSheet {
			var ss:StyleSheet = new StyleSheet();
			ss.setStyle("a", {textDecoration: "underline"});
			ss.setStyle("a:hover", {textDecoration: "none", color:"#000000"});
			return ss;
		}
		private function onTextLinkClick(e:TextEvent):void {
			if(e.text == "select" || e.text == "change") {
				_file = new File();
				_file.addEventListener(Event.SELECT, onDirSelected);
				_file.browseForDirectory("Workspace:");
			} else if(e.text == "use") {
				dispatchEvent(new WorkspaceSelectingEvent(WorkspaceSelectingEvent.ON_WORKSPACE_SELECTED));
			}
		}
		private function onDirSelected(e:Event):void {
			Debug.echo(className + " onDirSelected " + _file.nativePath);
			_dirPath = _file.nativePath.replace(/\\/g, "/");
			Session.setSession("workspaceDir", _dirPath);
			dispatchEvent(new WorkspaceSelectingEvent(WorkspaceSelectingEvent.ON_WORKSPACE_SELECTED));
		}
	
	}

}