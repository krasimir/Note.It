package lib.models.vos {
	
	import flash.filesystem.File;
	
	public class FileVO {
		
		public var file:File;
		public var key:String;
		public var content:String;
		
		protected var _data:Object;
		
		public function set data(d:Object):void {
			_data = d;
		}
		public function get data():Object {
			return _data;
		}
		public function updateContent():void {
			
		}
		
	}

}