package game.view.scene.ui.world
{
	import com.gs.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.sampler.Sample;
	
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;
	
	/**
	 * 资料板
	 * @author star
	 * 
	 */
	public class LibBar extends Sprite
	{
		public var close:SimpleButton;
		private var libBar:MovieClip;
		private var tower:SimpleButton;
		private var tip:SimpleButton;
		private var enemy:SimpleButton;
		private var back:SimpleButton;
		private var bots:Vector.<SimpleButton> = new Vector.<SimpleButton>();
		private var botId:int = 0;
		private var next:SimpleButton;
		private var last:SimpleButton;
		private var link:SimpleButton;
		
		private static var _instance :LibBar;
		
		public function LibBar($singlton:SingltonEnforcer)
		{
			if($singlton)
			{
				libBar = ClassManager.createInstance("library") as MovieClip;
				addChild(libBar);
				libBar.stop();
				close = libBar.butClose;
				tower = libBar.tower;
				tip = libBar.tip;
				enemy = libBar.enemy;
				back = libBar.butBack;
				next = libBar.next;
				last = libBar.last;
				link = libBar.link;
				back.visible = false;
				next.visible = false;
				last.visible = false;
				
				bots.push(tower,enemy,tip,link,close,back,next,last);
				init();
			}
		
		}
		
		public static function getInstance():LibBar
		{
			_instance ||= new LibBar(new SingltonEnforcer());
			return _instance;
		}
		
		public function init():void
		{
			for (var i:int = 0; i < bots.length; i++) 
			{
				bots[i].addEventListener(MouseEvent.CLICK,onMC);
			}
		}
		public function clear():void
		{
			for (var i:int = 0; i < bots.length; i++) 
			{
				bots[i].removeEventListener(MouseEvent.CLICK,onMC);
				
			}
		}
		protected function onMC(event:MouseEvent):void
		{
			SoundManager.getInstance().playEffectSound("mouseClick",1);
			botId = bots.indexOf(event.currentTarget);
			if(botId == 0){
				change(false);
				back.visible = true;
				libBar.gotoAndStop(2);
			}else if(botId == 1){
				change(false);
				back.visible = true;
				libBar.gotoAndStop(3);
			}else if(botId == 2){
				change(false);
				back.visible = true;
				libBar.gotoAndStop(4);
			}else if(botId == 3){
				//添加链接在此
			}else if(botId == 4){
				change(true);
				back.visible = false;
				TweenLite.to(this,0.3,{y:-500,onComplete:removeIt});
				libBar.gotoAndStop(1);
				clear();
			}else if(botId == 5){
				change(true);
				back.visible = false;
				libBar.gotoAndStop(1);
			}
		}
		
		private function removeIt():void
		{
			this.parent.removeChild(this);
		}
		public function change(vis:Boolean):void
		{
			
			for (var i:int = 0; i < 4; i++) 
			{
				if(vis == true)
					bots[i].visible = true;
				else
					bots[i].visible = false;
			}
			
		}
		public function huanDong():void
		{
			init();
			this.y = -200;
			TweenLite.to(this,0.3,{y:230});
		}
	}
}
internal class SingltonEnforcer{}