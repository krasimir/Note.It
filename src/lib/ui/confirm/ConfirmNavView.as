package lib.ui.confirm {
	
	import lib.controllers.events.ConfirmEvent;
	import lib.ui.pages.NavView;
	
	public class ConfirmNavView extends NavView {
		
		public function ConfirmNavView() {
			
			_links = [
				{action: "saveItem", events: [new ConfirmEvent(ConfirmEvent.YES)]},
				{action: "cancel", events: [new ConfirmEvent(ConfirmEvent.NO)]}
			];
			
			addIcons();
		}
		
	}

}