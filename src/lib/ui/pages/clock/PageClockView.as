package lib.ui.pages.clock {
	
	import com.krasimirtsonev.display.ButtonsHelper;
	import com.krasimirtsonev.utils.Delegate;
	import flash.display.MovieClip;
	import com.krasimirtsonev.utils.Debug;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	import lib.controllers.events.ConfirmEvent;
	import lib.controllers.events.GraphEvent;
	import lib.core.IPage;
	import lib.helpers.DateFormater;
	import com.krasimirtsonev.managers.tween.TweenManager;
	import lib.helpers.Styler;
	import flash.utils.setTimeout;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import com.krasimirtsonev.data.helpers.Session;
	
	public class PageClockView extends MovieClip implements IPage {
		
		private static var PAGE_PADDING:Number = 10;
		private static var ELEMENTS_PADDING:Number = 10;
		
		private var _data:Object;
		private var _times:Array;
		private var _nav:PageClockNavView;
		private var _clip:MovieClip;
		private var _over:MovieClip;
		private var _overClock:MovieClip;
		private var _overText:String;
		private var _fieldText:String;
		private var _infoText:String;
		private var _areaText:String;
		private var _startClockDate:Date;
		private var _currentDate:Date;
		private var _overNav:PageClockOverNavView;
		private var _madeHours:Number;
		private var _madeMinutes:Number;
		private var _sortedTimes:Object;
		private var _infoWindow:NativeWindow;
		private var _infoWindowContent:MovieClip;
		private var _pomodoro:Boolean = true;
		
		public function PageClockView(data:Object):void {
			
			_data = data;
			_pomodoro = Session.getSession("pomodoro") && Session.getSession("pomodoro") == "true" ? true : false;
			
			_clip = new A_ClockPageClip();
			_clip.area.editable = false;
			_clip.area.addEventListener(TextEvent.LINK, onTextAreaTextClick);
			addChild(_clip);
			Styler.styleTextArea(_clip.area);
			
			_nav = new PageClockNavView(_data.id);
			addChild(_nav);
			
			_over = new MovieClip();
			_over.graphics.beginFill(0x000000, 0.9);
			_over.graphics.drawRect(0, 0, 10, 10);
			_over.graphics.endFill();
			_over.visible = false;
			addChild(_over);
			
			_overClock = new A_ClockPageOverText();
			_overClock.visible = false;
			addChild(_overClock);
			
			_overNav = new PageClockOverNavView();
			_overNav.visible = false;
			addChild(_overNav);
			
			setFieldText();
			setOverText();
			setAreaText();
			
			if(data.autoStart) {
				setTimeout(startClock, 100);
			}
			
		}
		public function get id():String {
			return _data.id;
		}
		public function showPage():void {
			Debug.echo(className + " showPage");
			
		}
		public function hidePage():void {
			Debug.echo(className + " hidePage");
			stopClock();
		}
		public function updateVisuals(appWidth:Number, appHeight:Number):void {
			_nav.x = appWidth - _nav.width;
			_nav.y = appHeight - 20;
			_clip.field.x = _clip.field.y = PAGE_PADDING;
			_clip.field.width = appWidth - (PAGE_PADDING * 2);
			_clip.field.autoSize = TextFieldAutoSize.LEFT;
			_clip.field.htmlText = _fieldText;
			_clip.area.x = _clip.field.x;
			_clip.area.y = _clip.field.y + _clip.field.height + ELEMENTS_PADDING;
			_clip.area.width = _clip.field.width;
			_clip.area.height = appHeight - _clip.area.y - 40;
			_clip.info.x = _clip.field.x;
			_clip.info.y = _clip.area.y + _clip.area.height + ELEMENTS_PADDING;
			_clip.info.autoSize = TextFieldAutoSize.LEFT;
			_over.width = appWidth;
			_over.height = appHeight;
			_overClock.field.width = appWidth;
			_overClock.desc.width = appWidth;
			_overClock.field.autoSize = TextFieldAutoSize.CENTER;
			_overClock.field.htmlText = _overText;
			_overClock.field.y = (_over.height - _overClock.field.height) / 2;
			_overClock.desc.y = _overClock.field.y + _overClock.field.height + 10;
			_overNav.x = (_over.width / 2) - 23;
			_overNav.y = _overClock.desc.y + _overClock.desc.height + 40;
		}
		public function startClock(e:GraphEvent = null):void {
			Debug.echo(className + " startClock");
			_over.visible = true;
			_overClock.visible = true;
			_overNav.visible = true;
			stage.focus = _overClock.desc;
			TweenManager.alpha(_over, 0, 1, 0, 10);
			TweenManager.alpha(_overClock, 0, 1, 10, 10);
			TweenManager.alpha(_overNav, 0, 1, 10, 10);
			_startClockDate = _currentDate = new Date();
			addEventListener(Event.ENTER_FRAME, loop);
			if(Session.getSession("clockInfoWindowVisibile")) {
				addInfoWindow();
			}
		}
		public function stopClock(e:GraphEvent = null):void {
			Debug.echo(className + " stopClock");
			_over.visible = false;
			_overClock.visible = false;
			_overNav.visible = false;
			removeEventListener(Event.ENTER_FRAME, loop);
			if(_startClockDate && _currentDate) {
				dispatchEvent(new GraphEvent(GraphEvent.ADD_CLOCK_TIME, {id:_data.id, start:_startClockDate, end:_currentDate, hours:_madeHours, minutes:_madeMinutes, desc:_overClock.desc.text}));
				dispatchEvent(new GraphEvent(GraphEvent.SAVE_CLOCK_TIME, _data.id));
				setAreaText();
				_startClockDate = _currentDate = null;
			}
			removeInfoWindow();
		}
		public function clockTimesLoaded(times:Array):void {
			Debug.echo(className + " clockTimesLoaded times=" + times.length);
			_times = times;
			setAreaText();
		}
		public function changePomodoroMode(e:GraphEvent):void {
			_pomodoro = _pomodoro ? false : true;
			Session.setSession("pomodoro", _pomodoro ? "true" : "false");
		}
		public function changeClockInfoMode(e:GraphEvent):void {
			if(_infoWindow && !_infoWindow.closed) {
				Session.setSession("clockInfoWindowVisibile", false);
				removeInfoWindow();
			} else {
				Session.setSession("clockInfoWindowVisibile", true);
				Session.setSession("clockInfoWindowPositionX", 10);
				Session.setSession("clockInfoWindowPositionY", 10);
				addInfoWindow();
			}
		}
		private function setFieldText():void {
			_fieldText = "";
			_fieldText += _data.title ? '<font size="16">' + String(_data.title) + '</font>' : '';
			_infoText = "";
			_infoText += _data.dateCreated ? '<font color="#999999">created: ' + DateFormater.date2Label(_data.dateCreated) + ', </font>' : '';
			_infoText += _data.dateCreated ? '<font color="#999999">modified: ' + DateFormater.date2Label(_data.dateModified) + '</font> ' : '';
			_clip.field.htmlText = _fieldText;
			_clip.info.htmlText = _infoText;
		}
		private function setOverText():void {
			_overText = "";
			_overText += _data.title ? '<font size="20">' + String(_data.title) + '</font><br />' : '';
			if(_startClockDate && _currentDate) {
				_overText += 'start: ' + DateFormater.date2Label(DateFormater.date2Str(_startClockDate)) + '<br /><br />';
				var diff:Number = _currentDate.getTime() - _startClockDate.getTime();
				var seconds:Number = Math.floor((diff / 1000) % 60);
				var minutes:Number = _madeMinutes = Math.floor((diff / 1000 / 60) % 60);
				var hours:Number = _madeHours = Math.floor((diff / 1000 / 60 / 60));
				_overText += _pomodoro ? getTimeTextInPomodoroMode(hours, minutes, seconds, 50) : getTimeText(hours, minutes, seconds, 50);
			} else {
				_overText += ' <br /><br /> ';
			}
			_overClock.field.htmlText = _overText;
			_overClock.field.y = ((_over.height - _overClock.field.height) / 2) - 40;
			setTextOfInfoWindow(hours, minutes, seconds);
		}
		private function setAreaText():void {
			
			if(!_times) {
				_clip.area.htmlText = "loading ...";
				return;
			}
			
			// sorting by date
			_areaText = "";
			var times:Array = _times;
			var sortedTimes:Object = {};
			var numOfTimes:int = times.length;
			for(var i:int=0; i<numOfTimes; i++) {
				var prop:String = String(times[i].start).split(" ")[0];
				if(sortedTimes[prop]) {
					sortedTimes[prop].push(times[i]);
				} else {
					sortedTimes[prop] = [times[i]];
				}					
			}
			_sortedTimes = sortedTimes;
			
			// showing dates and times
			var totalHours:Number = 0;
			var totalMinutes:Number = 0;
			var lines:Array = [];
			for(var j:* in sortedTimes) {
				var currentTotalHours:Number = 0;
				var currentTotalMinutes:Number = 0;
				var tmpStr:String = "";
				var timesText:String = "";
				numOfTimes = sortedTimes[j].length;
				for(var k:int=0; k<numOfTimes; k++) {
					var desc:String = String(sortedTimes[j][k].desc).replace("\n", "").replace("\r", "");
					currentTotalHours += Number(sortedTimes[j][k].hours);
					currentTotalMinutes += Number(sortedTimes[j][k].mins);
					totalHours += Number(sortedTimes[j][k].hours);
					totalMinutes += Number(sortedTimes[j][k].mins);
					timesText += sortedTimes[j][k].start + ' - ' + sortedTimes[j][k].end + ' (' + getHoursAndMinsText(sortedTimes[j][k].hours, sortedTimes[j][k].mins) + ')';
					timesText += (desc != "" ? " - " + desc : "");	
					//timesText += ' - <u><a href="event:edit_' + j + '_' + k + '">edit</a></u> ';
					timesText += ' - <u><a href="event:delete_' + j + '_' + k + '">delete</a></u>';
					timesText += '<br />';
				}
				tmpStr += '<font size="16" color="#8B8B8B">' + j + ' (' + getHoursAndMinsText(currentTotalHours, currentTotalMinutes) + ')</font><br />';
				tmpStr += '<font color="#999999">' + timesText + "</font>";
				tmpStr += '<br /><br />';
				var line:Object = {
					date: DateFormater.str2Date(j + " 0:0"),
					text: tmpStr
				};
				lines.push(line);
			}
			var numOfLines:int = lines.length;
			for(i=0; i<numOfLines; i++) {
				for(k=i; k<numOfLines; k++) {
					if(lines[i].date > lines[k].date) {
						var tmp:Object = lines[i];
						lines[i] = lines[k];
						lines[k] = tmp;
					}
				}
			}
			
			_areaText += '<font size="20">Total: ' + getHoursAndMinsText(totalHours, totalMinutes) + '</font>';
			_areaText += '<br /><br />';
			for(i=numOfLines-1; i>=0; i--) {
				_areaText += lines[i].text;
			}
				
			_clip.area.htmlText = _areaText;
			
		}
		private function getHoursAndMinsText(hours:Number, mins:Number):String {
			if(mins >= 60) {
				hours += Math.floor(mins / 60);
				mins = Math.floor(mins % 60);
			}
			return (hours < 10 ? "0" + hours : hours) + ":" + (mins < 10 ? "0" + mins : mins);
		}
		private function loop(e:Event):void {
			_currentDate = new Date();
			setOverText();
		}
		private function onTextAreaTextClick(e:TextEvent):void {
			Debug.echo(className + " onTextAreaTextClick " + e.text);
			var params:Array = e.text.split("_");
			switch (params[0]) {
				case "edit":
					
				break;
				case "delete":
					dispatchEvent(new ConfirmEvent(ConfirmEvent.CONFIRM, {callback: Delegate.create(deleteTime, params[1], params[2])}));
				break;
			}
		}
		private function deleteTime(date:String, index:int):void {
			dispatchEvent(new GraphEvent(GraphEvent.REMOVE_CLOCK_TIME, _sortedTimes[date][index]));
			dispatchEvent(new GraphEvent(GraphEvent.SAVE_CLOCK_TIME, _data.id));
			setAreaText();
		}
		private function getTimeText(hours:Number, minutes:Number, seconds:Number, fontSize:int):String {
			var str:String = "";
			str += '<font size="' + fontSize + '">';
			str += hours < 10 ? "0" + hours : hours;
			str += ":";
			str += minutes < 10 ? "0" + minutes : minutes;
			str += ":";
			str += seconds < 10 ? "0" + seconds : seconds;
			str += '</font>';
			return str;
		}
		private function getTimeTextInPomodoroMode(hours:Number, minutes:Number, seconds:Number, fontSize:int, pomodoroColor:String = "#FFFFFF"):String {
			var str:String = "";
			var pomodorSessions:int = Math.floor((hours * 60) / 30) + Math.floor(minutes / 30);
			var pomodoroMinutes:int = (30 - (minutes % 30)) - 1;
			var pomodoroSeconds:int = 59 - seconds;
			str += '<font size="' + fontSize + '" color="' + (pomodoroColor) + '">';
			str += pomodoroMinutes < 10 ? "0" + pomodoroMinutes : pomodoroMinutes;
			str += ":";
			str += pomodoroSeconds < 10 ? "0" + pomodoroSeconds : pomodoroSeconds;
			str += '</font><font size="' + fontSize + '" > | </font>';
			str += '<font size="' + Math.ceil(fontSize/2) + '" color="#999999">';
			str += pomodorSessions + " pomodori | ";
			str += hours < 10 ? "0" + hours : hours;
			str += ":";
			str += minutes < 10 ? "0" + minutes : minutes;
			str += ":";
			str += seconds < 10 ? "0" + seconds : seconds;
			str += '</font>';
			if(_infoWindow && !_infoWindow.closed && _infoWindowContent) {
				if(pomodoroMinutes <= 4) {
					_infoWindowContent.back.visible = true;
				} else {
					_infoWindowContent.back.visible = false;
				}
			}
			return str;
		}
		// info window
		private function addInfoWindow():void {
			
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.maximizable = false;
			options.resizable = false;
			options.minimizable = true;
			options.systemChrome = NativeWindowSystemChrome.STANDARD;
			
			_infoWindow = new NativeWindow(options);
			_infoWindow.alwaysInFront = true;
			_infoWindow.width = 195;
			_infoWindow.height = 70;
			_infoWindow.x = Session.getSession("clockInfoWindowPositionX") ? Session.getSession("clockInfoWindowPositionX") : 10;
			_infoWindow.y = Session.getSession("clockInfoWindowPositionY") ? Session.getSession("clockInfoWindowPositionY") : 10;
			_infoWindow.visible = true;
			_infoWindow.orderToFront();
			_infoWindow.addEventListener(Event.CLOSING, onInfoWindowClose);
			
			_infoWindowContent = new A_ClockInfo();
			_infoWindowContent.field.width = 195;
			_infoWindowContent.field.autoSize = TextFieldAutoSize.LEFT;
			_infoWindowContent.back.width = 195;
			_infoWindowContent.back.height = 70;
			_infoWindowContent.back.visible = false;
			
			_infoWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
			_infoWindow.stage.align = StageAlign.TOP_LEFT;
			_infoWindow.stage.addChild(_infoWindowContent);
			
		}
		private function removeInfoWindow():void {
			if(_infoWindow && !_infoWindow.closed) {
				Session.setSession("clockInfoWindowPositionX", _infoWindow.bounds.x);
				Session.setSession("clockInfoWindowPositionY", _infoWindow.bounds.y);
				_infoWindow.close();
				_infoWindow = null;
			}
		}
		private function setTextOfInfoWindow(hours:Number, minutes:Number, seconds:Number):void {
			if(_infoWindow && !_infoWindow.closed && _infoWindowContent) {
				var text:String = "";
				text += String(_data.title).length > 30 ? String(_data.title).substr(0, 30) + "..." : _data.title;
				text += "<br />";
				text += _pomodoro ? getTimeTextInPomodoroMode(hours, minutes, seconds, 20, "#000000") : getTimeText(hours, minutes, seconds, 20);
				_infoWindowContent.field.htmlText = text;
			}
		}
		private function onInfoWindowClose(e:Event):void {
			e.preventDefault();
			removeInfoWindow();
			stopClock();
		}
		// other
		private function get className():String {
			return "PageClockView";
		}
	
	}

}