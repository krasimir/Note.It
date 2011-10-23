package lib.helpers {
	
	import com.krasimirtsonev.data.helpers.Session;
	import com.krasimirtsonev.utils.Debug;
	import com.krasimirtsonev.utils.Delegate;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.events.ScreenMouseEvent;
	import flash.geom.Rectangle;
	import lib.contexts.NoteItContext;
	import lib.controllers.events.SystemTrayEvent;
	
	public class SystemTray extends EventDispatcher {
		
		private var _container:DisplayObjectContainer;
		private var _context:NoteItContext;
		private var _systemTrayMenu:NativeMenu;
		private var _nativeWindow:NativeWindow;
		
		public function SystemTray(displayObjectContainer:DisplayObjectContainer, context:NoteItContext) {
			
			_container = displayObjectContainer;
			_context = context;
			
			_nativeWindow = _container.stage.nativeWindow;
			_nativeWindow.addEventListener(Event.CLOSING, onAppClosing);
			_nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, onAppStateChange);
			_nativeWindow.visible = true;
			
			// init the system tray icon and set the initial position and size of the main app window
			initSystemTray();
			initPositionAndSize();
			
		}
		public function get nativeWindow():NativeWindow {
			return _nativeWindow;
		}
		private function get className():String {
			return "SystemTray";
		}
		// position and size
		private function initPositionAndSize():void {
			var w:Number = (Session.getSession("initialWidth") || _context.appModel.appWidth) + 2;
			var h:Number = (Session.getSession("initialHeight") || _context.appModel.appHeight) + 22;
			var initX:Number = Session.getSession("initialX") || (Screen.mainScreen.bounds.width - w) / 2;
			var initY:Number = Session.getSession("initialY") || (Screen.mainScreen.bounds.height - h) / 2;			
			_nativeWindow.bounds = new Rectangle(initX, initY, w, h);
		}
		private function storePositionAndSize():void {
			Debug.echo(className + " storePositionAndSize");
			if(_nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED) {
				Session.setSession("initialWidth", _context.appModel.appWidth);
				Session.setSession("initialHeight", _context.appModel.appHeight);
				Session.setSession("initialX", 0);
				Session.setSession("initialY", 0);
			} else {
				Session.setSession("initialWidth", _context.appModel.appWidth);
				Session.setSession("initialHeight", _context.appModel.appHeight);
				Session.setSession("initialX", _nativeWindow.bounds.x);
				Session.setSession("initialY", _nativeWindow.bounds.y);
			}
		}
		private function onAppClosing(e:Event):void {			
			e.preventDefault();
			onAppClose();
		}
		private function onAppClose():void {
			storePositionAndSize();
			_context.onAppClose();
			NativeApplication.nativeApplication.exit();
		}
		private function onAppStateChange(e:NativeWindowDisplayStateEvent):void {
			if(e.afterDisplayState == NativeWindowDisplayState.MINIMIZED) {
				if(NativeApplication.supportsSystemTrayIcon) {
					e.preventDefault();
					closeToTray();
				}
			} else if(e.afterDisplayState == NativeWindowDisplayState.MAXIMIZED){
				
			} else if(e.afterDisplayState == NativeWindowDisplayState.NORMAL){
				
			}
		}
		// tray
		private function initSystemTray():void {
			if(NativeApplication.supportsSystemTrayIcon) {
				
				NativeApplication.nativeApplication.autoExit = false;
				var icon:SystemTrayIcon = (NativeApplication.nativeApplication.icon as SystemTrayIcon);
				
				_systemTrayMenu = new NativeMenu();
				_systemTrayMenu.addItem(createNativeMenuItem("Open", Delegate.create(onSystemTrayMenuClick, "open")));
				_systemTrayMenu.addItem(createNativeMenuItem("Close", Delegate.create(onSystemTrayMenuClick, "close")));
				_systemTrayMenu.addItem(createNativeMenuItem("", null, true));
				_systemTrayMenu.addItem(createNativeMenuItem("Exit", Delegate.create(onSystemTrayMenuClick, "exit")));
				
				var bitmapData:BitmapData = new BitmapData(16, 16);
				bitmapData.draw(new A_IconApp16x16());
				
				icon.tooltip = "Note.It";
				icon.bitmaps = [bitmapData];
				icon.addEventListener(ScreenMouseEvent.CLICK, onTrayIconLeftClick);
				icon.menu = _systemTrayMenu;
				
			}
		}
		private function onSystemTrayMenuClick(e:Event, type:String):void {
			Debug.echo(className + " onSystemTrayMenuClick");
			switch (type) {
				case "open":
					openFromTheTray();
				break;
				case "close":
					closeToTray();
				break;
				case "exit":
					onAppClose();
				break;
			}
		}
		private function openFromTheTray():void {
			_nativeWindow.visible = true;
			_nativeWindow.orderToFront();
			_container.stage.frameRate = 31;
			dispatchEvent(new SystemTrayEvent(SystemTrayEvent.OPEN_FROM_TRAY));
		}
		private function closeToTray():void {
			_nativeWindow.visible = false;
			_container.stage.frameRate = 1;
		}
		private function createNativeMenuItem(label:String, callback:Function, isSeparator:Boolean = false):NativeMenuItem {
			var item:NativeMenuItem = new NativeMenuItem(label, isSeparator);
			if(callback != null) {
				item.addEventListener(Event.SELECT, callback);
			}
			return item;
		}
		private function onTrayIconLeftClick(e:Event):void {			
			if(_nativeWindow.visible) {
				closeToTray();
			} else {
				openFromTheTray();
			}			
		}
		
	}

}