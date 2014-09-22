package game.view.scene.ui.battle
{
	import com.gs.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.event.BattleEvent;
	import game.event.SceneChangeEvent;
	
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;

	public class SetBar extends Sprite
	{
		private var mainMC :MovieClip; 
		public var resume:SimpleButton;
		private var quit:SimpleButton;
		public var restart:SimpleButton;
		
		private var bot1:SimpleButton;
		private var bot2:SimpleButton;
		private var bot3:SimpleButton;
		private var bot4:SimpleButton;
		private var bot5:SimpleButton;
		private var bot6:SimpleButton;
		private var bot7:SimpleButton;
		private var bot8:SimpleButton;
		private var bot9:SimpleButton;
		private var bot10:SimpleButton;
		private var bot11:SimpleButton;
		
		private var bots:Vector.<SimpleButton> = new Vector.<SimpleButton>();
		private var botNum:String = "";
		public function SetBar()
		{
		  mainMC = ClassManager.createInstance("settingBar") as MovieClip;
		  restart = mainMC.restart;
		  resume = mainMC.resume;	
		  quit = mainMC.quit;
		  bot1 = mainMC.bot1;
		  bot2 = mainMC.bot2;
		  bot3 = mainMC.bot3;
		  bot4 = mainMC.bot4;
		  bot5 = mainMC.bot5;
		  bot6 = mainMC.bot6;
		  bot7 = mainMC.bot7;
		  bot8 = mainMC.bot8;
		  bot9 = mainMC.bot9;
		  bot10 = mainMC.bot10;
		  bot11 = mainMC.bot11;
		  
		  bots.push(bot1);bots.push(bot2);bots.push(bot3);bots.push(bot4);bots.push(bot5);
		  bots.push(bot6);bots.push(bot7);bots.push(bot8);bots.push(bot9);bots.push(bot10);
		  bots.push(bot11);
		  
		  
		  addChild(mainMC);
		  bot1.alpha = bot3.alpha = bot5.alpha = bot7.alpha = bot8.alpha = bot10.alpha = 0;
		  
		}
		public function init():void
		{
		  for (var i:int = 0; i < 11; i++) 
		  {
		      bots[i].addEventListener(MouseEvent.CLICK,onBot)
		  }
		  restart.addEventListener(MouseEvent.CLICK,onRestart);
		  resume.addEventListener(MouseEvent.CLICK,onResume);
		  quit.addEventListener(MouseEvent.CLICK,onQuit);
			
		}
		public function clear():void
		{
			for (var i:int = 0; i < 11; i++) 
			{
				bots[i].removeEventListener(MouseEvent.CLICK,onBot)
			}
			restart.removeEventListener(MouseEvent.CLICK,onRestart);
			resume.removeEventListener(MouseEvent.CLICK,onResume);
			quit.removeEventListener(MouseEvent.CLICK,onQuit);
		}
		protected function onBot(event:MouseEvent):void
		{
			playEffectSound();
			botNum = event.currentTarget.name;
			if(botNum == "bot1"){
				bot1.alpha = 1;
				bot2.alpha  = 0;
				soundEffect(true);
				//关闭音效
			}else if(botNum == "bot2"){
				bot2.alpha = 1;
				bot1.alpha  = 0;
				soundEffect(false);
				//打开音效
			}else if(botNum == "bot3"){
				bot3.alpha = 1;
				bot4.alpha  = 0;
				sound(true);
				//关闭声音
			}else if(botNum == "bot4"){
				bot4.alpha = 1;
				bot3.alpha  = 0;
				sound(false);
				//打开声音
			}else if(botNum == "bot5"){
				bot5.alpha = 1;
				bot6.alpha  = 0;
				tips(false);
				//关闭提示
			}else if(botNum == "bot6"){
				bot6.alpha = 1;
				bot5.alpha  = 0;
				tips(true);
				//打开提示
			}else if(botNum == "bot7"){
				bot7.alpha = 1;
				bot8.alpha  = 0;
				bot9.alpha  = 0;
				quality(1);
				//画质低
			}else if(botNum == "bot8"){
				bot8.alpha = 1;
				bot7.alpha  = 0;
				bot9.alpha  = 0;
				quality(2);
				//画质中
			}else if(botNum == "bot9"){
				bot9.alpha = 1;
				bot7.alpha  = 0;
				bot8.alpha  = 0;
				quality(3);
				//画质高
			}else if(botNum == "bot10"){
				bot10.alpha = 1;
				bot11.alpha  = 0;
				autoPause(false);
				//自动暂停关
			}else if(botNum == "bot11"){
				bot11.alpha = 1;
				bot10.alpha  = 0;
				autoPause(true);
				//自动暂停开
			}
			
			
		}
		
		private function autoPause(param0:Boolean):void
		{
//			dispatchEvent(new BattleEvent(BattleEvent.AUTO_PAUSE));
		}
		
		private function quality(param0:int):void
		{
			var data:Object = new Object();
			data.id = param0;
			dispatchEvent(new BattleEvent(BattleEvent.CHANGE_QUALITY,data));
		}
		
		private function tips(param0:Boolean):void
		{
			dispatchEvent(new BattleEvent(BattleEvent.TIPS));
		}
		
		private function sound(param0:Boolean):void
		{
			SoundManager.getInstance().closeBgMusic(param0);
//			SoundManager.getInstance().MusicPuase();
		}
		
		private function soundEffect(param0:Boolean):void
		{
			SoundManager.getInstance().closeEffectMusic(param0);
		}
		
		protected function onQuit(event:MouseEvent):void
		{
			playEffectSound();
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.BACK_WORLD_SCENE));
			this.y = -500;
		}
		
		protected function onResume(event:MouseEvent):void
		{
			playEffectSound();
			dispatchEvent(new BattleEvent(BattleEvent.CLOSE_SET));
			TweenLite.to(this,0.4,{y:-500});
			clear();
		}
		
		protected function onRestart(event:MouseEvent):void
		{
			playEffectSound();
			dispatchEvent(new BattleEvent(BattleEvent.CLOSE_SET));
			TweenLite.to(this,0.4,{y:-500});
			clear();
		}
		
		public function huanDong():void{
			TweenLite.to(this,0.4,{y:200});
		}
		public function playEffectSound():void
		{
			SoundManager.getInstance().playEffectSound("mouseClick",1);
		}
		
	}
}