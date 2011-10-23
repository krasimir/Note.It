package lib.models.vos {
	
	import flash.filesystem.File;
	import lib.models.vos.FileVO;
	import com.krasimirtsonev.utils.Debug;
	import lib.helpers.factories.XMLContentFactory;
	import lib.helpers.DateFormater;
	
	public class ConfigVO extends FileVO {
		
		public function ConfigVO() {
			key = "_CONFIG";
		}
		public override function updateContent():void {
			content = '';
			content += '<xml>';
			content += '<settings>';
			content += '</settings>';
			content += '<mainPageGraph x="' + _data.mainPageGraph.x + '" y="' + _data.mainPageGraph.y + '">';
			var numOfGraphItems:int = _data.mainPageGraph.graphItem.length;
			for(var i:int=0; i<numOfGraphItems; i++) {
				content += XMLContentFactory.getGraphElementAsXMLFromObject(_data.mainPageGraph.graphItem[i]);
			}
			content += '</mainPageGraph>';
			content += '</xml>';
		}
		public function updateParent(childId:String, parentId:String):void {
			var numOfGraphItems:int = _data.mainPageGraph.graphItem.length;
			var child:Object; 
			var parent:Object; 
			for(var i:int=0; i<numOfGraphItems; i++) {
				if(childId == _data.mainPageGraph.graphItem[i].id.toString()) {
					child = _data.mainPageGraph.graphItem[i];
				}
				if(parentId == _data.mainPageGraph.graphItem[i].id.toString()) {
					parent = _data.mainPageGraph.graphItem[i];
				}
			}
			if(child && parent) {
				child.parent = childId == parentId ? "0" : parentId;
				child.color = parent.color;
			}
		}
		public function addNewGraphItem():Object {
			var data:Object = XMLContentFactory.getNewGraphElement();
			_data.mainPageGraph.graphItem.push(data);
			return data;
		}
		public function deleteItem(id:String):void {
			var numOfGraphItems:int = _data.mainPageGraph.graphItem.length;
			var newArr:Array = [];
			for(var i:int=0; i<numOfGraphItems; i++) {
				if(id != _data.mainPageGraph.graphItem[i].id.toString()) {
					newArr.push(_data.mainPageGraph.graphItem[i]);
				}
			}
			_data.mainPageGraph.graphItem = newArr;
		}
		public function getItem(id:String):Object {
			var numOfGraphItems:int = _data.mainPageGraph.graphItem.length;
			for(var i:int=0; i<numOfGraphItems; i++) {
				if(id == _data.mainPageGraph.graphItem[i].id.toString()) {
					return _data.mainPageGraph.graphItem[i];
				}
			}
			return null;
		}
		public function saveItem(data:Object, newData:Object):void {
			if(data && newData) {
				for(var i:* in newData) {
					data[i] = newData[i];
				}
			}
		}
		public function changeExpand(id:String):void {
			var numOfGraphItems:int = _data.mainPageGraph.graphItem.length;
			for(var i:int=0; i<numOfGraphItems; i++) {
				if(id == _data.mainPageGraph.graphItem[i].id.toString()) {
					var data:Object = _data.mainPageGraph.graphItem[i];
					if(data.actions.expand == "no") {
						data.actions.expand = "yes";
					} else {
						data.actions.expand = "no";
					}
				}
			}
		}
		
	}

}