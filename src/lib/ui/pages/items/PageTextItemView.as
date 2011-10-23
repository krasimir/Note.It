package lib.ui.pages.items {
	
	import com.krasimirtsonev.utils.Delegate;
	import flash.display.MovieClip;
	import com.krasimirtsonev.utils.Debug;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import lib.controllers.events.PagesEvent;
	import lib.core.IPage;
	import com.krasimirtsonev.display.DisplayHelper;
	import fl.controls.ColorPicker;
	import fl.events.ColorPickerEvent;
	import lib.helpers.DateFormater;
	import lib.helpers.Styler;
	import lib.ui.pages.graph.PageGraphView;
	
	public class PageTextItemView extends MovieClip implements IPage {
		
		private static var PAGE_PADDING:Number = 10;
		private static var ELEMENTS_PADDING:Number = 10;
		
		private var _data:Object;
		private var _newData:Object;
		private var _clip:MovieClip;
		private var _nav:PageTextItemNavView;
		private var _infoText:String;
		
		public function PageTextItemView(data:Object):void {
			
			_data = data;
			_newData = {};
			
			_clip = new A_TextItemPageClip();
			_clip.x = _clip.y = PAGE_PADDING;
			addChild(_clip);
			
			setTextFieldEvents(_clip.title, "title", _data.title ? _data.title : "");
			setTextFieldEvents(_clip.desc, "desc", _data.desc ? _data.desc : "");
			setColorPickerEvents(_clip.color, "color", DisplayHelper.colorStringToHex(_data.color));
			// Styler.styleTextArea(_clip.desc);
			
			_infoText = "";
			_infoText += _data.dateCreated ? '<font color="#999999">created: ' + DateFormater.date2Label(_data.dateCreated) + ', </font>' : '';
			_infoText += _data.dateCreated ? '<font color="#999999">modified: ' + DateFormater.date2Label(_data.dateModified) + '</font> ' : '';
			
			_nav = new PageTextItemNavView(_data.id, _data.isNewItem);
			addChild(_nav);
			
		}
		private function get className():String {
			return "PageTextItemView";
		}
		private function setTextFieldEvents(field:Object, property:String, defaultValue:String):void {
			field.text = defaultValue;
			field.addEventListener(Event.CHANGE, Delegate.create(onTextFieldChange, field, property));
		}
		private function onTextFieldChange(e:Event, field:Object, property:String):void {
			_newData[property] = field.text;
		}
		private function setColorPickerEvents(picker:ColorPicker, property:String, defaultValue:uint):void {
			picker.selectedColor = defaultValue;
			picker.addEventListener(ColorPickerEvent.CHANGE, Delegate.create(onColorPickerChange, picker, property));
		}
		private function onColorPickerChange(e:Event, picker:ColorPicker, property:String):void {
			_newData[property] = "#" + DisplayHelper.colorHexToString(picker.selectedColor);
		}
		private function onKeyUp(e:KeyboardEvent):void {
			switch (e.charCode) {
				case 27:
					dispatchEvent(new PagesEvent(PagesEvent.SHOW_PAGE_GRAPH));
				break;
			}
		}
		public function get data():Object {
			return _data;
		}
		public function get newData():Object {
			return _newData;
		}
		public function showPage():void {
			Debug.echo(className + " showPage title=" + _data.title);
			if(stage) {
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			stage.focus = _clip.desc;
			_clip.desc.setSelection(_clip.desc.length, _clip.desc.length);
		}
		public function hidePage():void {
			Debug.echo(className + " hidePage");
			if(stage) {
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			if(_nav) {
				_nav.clear();
			}
		}
		public function updateVisuals(appWidth:Number, appHeight:Number):void {
			_clip.title.width = appWidth - (PAGE_PADDING * 2) - 25 - ELEMENTS_PADDING;
			_clip.color.x = _clip.title.width + ELEMENTS_PADDING;
			_clip.desc.y = _clip.title.height + ELEMENTS_PADDING;
			_clip.desc.width = appWidth - (PAGE_PADDING * 2);
			_clip.desc.height = appHeight - (PAGE_PADDING * 2) - _clip.desc.y - _nav.height - 5;
			_clip.info.x = 0;
			_clip.info.y = _clip.desc.y + _clip.desc.height + ELEMENTS_PADDING;
			_clip.info.width = appWidth - _nav.width - ELEMENTS_PADDING;
			_clip.info.autoSize = TextFieldAutoSize.LEFT;
			_clip.info.htmlText = _infoText;
			_nav.x = appWidth - _nav.width;
			_nav.y = appHeight - 20;
		}
	
	}

}