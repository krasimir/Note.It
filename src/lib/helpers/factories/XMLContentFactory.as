package lib.helpers.factories {
	
	import lib.helpers.DateFormater;
	import mx.utils.UIDUtil;
	import com.krasimirtsonev.utils.Debug;
	
	public class XMLContentFactory {
		
		/*private static var TAB1:String = "\t";
		private static var TAB2:String = "\t\t";
		private static var TAB3:String = "\t\t\t";
		private static var TAB4:String = "\t\t\t\t";
		private static var NEW_LINE:String = "\n";*/
		
		private static var TAB1:String = "";
		private static var TAB2:String = "";
		private static var TAB3:String = "";
		private static var TAB4:String = "";
		private static var NEW_LINE:String = "";
		
		public static function getConfigXML():String {
			
			var graphItemNoteItId:String = UIDUtil.createUID();
			
			var xml:String = "";
			xml += '<xml>' + NEW_LINE;
			xml += TAB1 + '<settings>' + NEW_LINE;
			xml += TAB1 + '</settings\n>' + NEW_LINE;
			xml += TAB1 + '<mainPageGraph x="0" y="0">' + NEW_LINE;
			xml += getGraphElementAsXML("Note.It", 38, 51, graphItemNoteItId, "0", "#2CB11E", {expand: "yes", clock: 1});
			xml += TAB1 + '</mainPageGraph>' + NEW_LINE;
			xml += '</xml>';
			return xml;
			
		}
		public static function getGraphElementAsXML(
			title:String, 
			x:Object, 
			y:Object, 
			id:String, 
			parent:String = "0", 
			color:String = "#000000", 
			actions:Object = null,
			dateCreated:String = "",
			dateModified:String = "",
			desc:String = ""
		):String {
			var xml:String = "";
			xml += TAB2 + '<graphItem>' + NEW_LINE;
			xml += TAB3 + '<id>' + (id == null ? UIDUtil.createUID() : id) + '</id>' + NEW_LINE;
			xml += TAB3 + '<parent>' + (parent == null ? 0 : parent) + '</parent>' + NEW_LINE;
			xml += TAB3 + '<dateCreated>' + (dateCreated == "" || dateCreated == "null" || dateCreated == null ? DateFormater.nowAsStr : dateCreated) + '</dateCreated>' + NEW_LINE;
			xml += TAB3 + '<dateModified>' + (dateModified == "" || dateModified == "null" || dateModified == null ? DateFormater.nowAsStr : dateModified) + '</dateModified>' + NEW_LINE;
			xml += TAB3 + '<title><![CDATA[' + (title == null ? "New Item" : title) + ']]></title>' + NEW_LINE;
			xml += TAB3 + '<desc><![CDATA[' + (desc == null ? "" : desc) + ']]></desc>' + NEW_LINE;
			xml += TAB3 + '<x>' + (x == null ? 0 : x) + '</x>' + NEW_LINE;
			xml += TAB3 + '<y>' + (y == null ? 0 : y) + '</y>' + NEW_LINE;
			xml += TAB3 + '<color>' + (color == null ? "#000000" : color) + '</color>' + NEW_LINE;
			xml += TAB3 + '<actions>' + NEW_LINE;
			if(actions) {
				for(var i:* in actions) {
					xml += TAB4 + '<' + i + '>' + actions[i] + '</' + i + '>' + NEW_LINE;
				}
			}
			if(!actions || actions.expand == null) {
				xml += TAB4 + '<expand>yes</expand>' + NEW_LINE;
			}
			if(!actions || actions.clock == null) {
				xml += TAB4 + '<clock>1</clock>' + NEW_LINE;
			}
			xml += TAB3 + '</actions>' + NEW_LINE;
			xml += TAB2 + '</graphItem>' + NEW_LINE;
			return xml;
		}
		public static function getGraphElementAsXMLFromObject(obj:Object):String {
			return getGraphElementAsXML(
				obj.title,
				obj.x,
				obj.y,
				obj.id,
				obj.parent,
				obj.color,
				obj.actions,
				obj.dateCreated,
				obj.dateModified,
				obj.desc
			);
		}
		public static function getNewGraphElement():Object {
			return {
				id: UIDUtil.createUID(),
				parent: 0,
				dateCreated: DateFormater.nowAsStr,
				dateModified: DateFormater.nowAsStr,
				title:"NewNote",
				color: "#000000",
				actions: {
					changeParent: 1,
					deleteItem: 1,
					editItem: 1,
					expand: "yes",
					clock: 1
				}
			}
		}
		public static function getTimeDefaultXML():String {
			return '<xml><times></times></xml>';
		}
		public static function getTimeXMLFromObject(obj:Object):String {
			var xml:String = '';
			if(obj && typeof Object != "string" && obj.start && obj.end) {
				xml += TAB2 + '<time>' + NEW_LINE;
				xml += TAB3 + '<start>' + obj.start + '</start>' + NEW_LINE;
				xml += TAB3 + '<end>' + obj.end + '</end>' + NEW_LINE;
				xml += TAB3 + '<hours>' + obj.hours + '</hours>' + NEW_LINE;
				xml += TAB3 + '<mins>' + obj.mins + '</mins>' + NEW_LINE;
				xml += TAB3 + '<desc><![CDATA[' + (obj.desc ? obj.desc : '') + ']]></desc>' + NEW_LINE;
				xml += TAB2 + '</time>' + NEW_LINE;
			}
			return xml;
		}
		
	}

}