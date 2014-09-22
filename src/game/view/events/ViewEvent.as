package  game.view.events
{
	import flash.events.Event;

	public class ViewEvent extends Event
	{
		public var DATA :Object;
		
		public function ViewEvent(type:String,data:Object=null)
		{
			super(type);
			(data) && (DATA = data);
		}
		
	}
}