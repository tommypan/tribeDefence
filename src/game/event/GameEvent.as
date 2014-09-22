package game.event
{
	import flash.events.Event;
	
	/**
	 * 
	 * @author panhao
	 * @date 2013-8-1
	 */	
	public class GameEvent extends Event
	{
		public  var data:Object;
		
		public function GameEvent(type:String,data_:Object = null)
		{
			super(type);
			data_ && (data=data_);
		}
	}
}