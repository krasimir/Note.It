package lib.helpers {
	
	import fl.controls.TextArea;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	public class Styler {
		
		public static function styleTextArea(area:TextArea):void {
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Tahoma"
			textFormat.size = 11;
			 
			area.setStyle("textFormat", textFormat);
			area.setStyle("embedFonts", true);
			
		}
		
	}

}