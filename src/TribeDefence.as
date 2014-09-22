package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	import game.GameContext;
	import game.view.scene.BattleScene;
	import game.view.scene.WorldScene;
	
	
	[SWF(width = "700" , height = "600" , backgroundColor = "0x000000")]
	public class TribeDefence extends Sprite
	{
		private var context:GameContext;
		
		public function TribeDefence()
		{
			this.addEventListener(Event.ENTER_FRAME,init);
		}
		
		public function init(e:Event):void
		{
			//Security.allowDomain("*");
			//			if(ExternalInterface.available)
			//			{
			//				var obj :Object = ExternalInterface.call("say");
			//				trace("调用成功？",obj);
			//			}
			if(stage != null)
			{
				context = new GameContext(this);
				this.removeEventListener(Event.ENTER_FRAME,init);
			}
			
			
			//var testNumA :int=4;
			//trace(testNumA>>3);//按位于操作num*2的操作。除多了就是0了。左乘又除
		}
		
		
	}
	
}