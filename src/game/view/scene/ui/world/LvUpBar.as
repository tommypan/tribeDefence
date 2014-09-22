package game.view.scene.ui.world
{
	import com.gs.TweenLite;
	
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import qmang2d.loader.LoaderManager;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;
	
	/**
	 * 升级面板
	 * @author Star
	 * 
	 */
	public class LvUpBar extends Sprite
	{
		private var lvBar:MovieClip;
		
		private var undo:SimpleButton;
		private var done:SimpleButton;
		private var reset:SimpleButton;
		
		public var starNum:TextField;
		//六排升级按钮
		private var a1:SimpleButton;
		private var a2:SimpleButton;
		private var a3:SimpleButton;
		private var a4:SimpleButton;
		
		private var b1:SimpleButton;
		private var b2:SimpleButton;
		private var b3:SimpleButton;
		private var b4:SimpleButton;
		
		private var c1:SimpleButton;
		private var c2:SimpleButton;
		private var c3:SimpleButton;
		private var c4:SimpleButton;
		
		private var d1:SimpleButton;
		private var d2:SimpleButton;
		private var d3:SimpleButton;
		private var d4:SimpleButton;
		
		private var e1:SimpleButton;
		private var e2:SimpleButton;
		private var e3:SimpleButton;
		private var e4:SimpleButton;
		
		private var f1:SimpleButton;
		private var f2:SimpleButton;
		private var f3:SimpleButton;
		private var f4:SimpleButton;
		private var curBotId:int; 
		/**星星个数*/
		private var starN:int = 0;
		private var bots:Vector.<SimpleButton> = new Vector.<SimpleButton>();
		/**用于记录总星星数*/
		public var starAll:int = 0;
		public function LvUpBar(star:int=0)
		{
			
			starAll = star;
			starN = starAll;
			lvBar = ClassManager.createInstance("updataBar") as MovieClip;
			addChild(lvBar);
			starNum = lvBar.starNum;
			starNum.text = starAll.toString();
			undo = lvBar.undo;
			done = lvBar.done;
			reset = lvBar.reset;
			a1 = lvBar.a1;
			a2 = lvBar.a2;
			a3 = lvBar.a3;
			a4 = lvBar.a4;
			
			b1 = lvBar.b1;
			b2 = lvBar.b2;
			b3 = lvBar.b3;
			b4 = lvBar.b4;
			
			c1 = lvBar.c1;
			c2 = lvBar.c2;
			c3 = lvBar.c3;
			c4 = lvBar.c4;
			
			d1 = lvBar.d1;
			d2 = lvBar.d2;
			d3 = lvBar.d3;
			d4 = lvBar.d4;
			
			e1 = lvBar.e1;
			e2 = lvBar.e2;
			e3 = lvBar.e3;
			e4 = lvBar.e4;
			
			f1 = lvBar.f1;
			f2 = lvBar.f2;
			f3 = lvBar.f3;
			f4 = lvBar.f4;
			bots.push(a1,a2,a3,a4);//0-3  ,4
			bots.push(b1,b2,b3,b4);//4-7  ,8
			bots.push(c1,c2,c3,c4);//8-11  ,12
			bots.push(d1,d2,d3,d4);//12-15  ,16
			bots.push(e1,e2,e3,e4);//16-19  ,20
			bots.push(f1,f2,f3,f4);//20-23  ,24
			
			initLv();
			
		}
		private function initLv():void
		{
			for (var i:int = 0; i < bots.length; i++) 
			{
				bots[i].alpha = 0.4;
			}
			if(starAll >= 2){
				var k:int = 0;
				bots[k].alpha = bots[k+4].alpha = bots[k+8].alpha = bots[k+12].alpha = bots[k+16].alpha = bots[k+20].alpha = 0.7;
			}
			init();
			
		}
		public function init():void
		{
			undo.addEventListener(MouseEvent.CLICK,onUndo);
			done.addEventListener(MouseEvent.CLICK,onDone);
			reset.addEventListener(MouseEvent.CLICK,onReset);
			for (var i:int = 0; i < bots.length; i++) 
			{
				if(bots[i].alpha > 0.6 && bots[i].alpha < 0.8){
					bots[i].addEventListener(MouseEvent.CLICK,onClick);
				}
			}
			
		}
		protected function onClick(event:MouseEvent):void
		{
			playEffectSound();
			curBotId = bots.indexOf(event.target);
			
			for (var i:int = 0; i < 6; i++) 
			{
				if(starN >= 2){
					if(curBotId == 4*i ){
						changeListen(2);
					}else if(curBotId == 4*i + 1 && starN >= 5 ){
						changeListen(5);
					}else if(curBotId == 4*i + 2 && starN >= 8){
						changeListen(8);
					}else if(curBotId == 4*i + 3 && starN >= 10){
						bots[curBotId].removeEventListener(MouseEvent.CLICK,onClick);
						bots[curBotId].alpha = 1;
						starN = starN - 10;
						changeStar(starN);
					}else {
						trace("信息出错,当前不可点击");
					}
				}else{
					trace("星星不足");
				}
				
			}
		}
		
		private function changeListen(num:int):void
		{
			bots[curBotId].removeEventListener(MouseEvent.CLICK,onClick);
			bots[curBotId+1].addEventListener(MouseEvent.CLICK,onClick);
			bots[curBotId].alpha = 1;
			bots[curBotId+1].alpha = 0.7;
			starN = starN - num;
			changeStar(starN);
		}
		private function botLight():void
		{
			for (var i:int = 0; i < bots.length; i++) 
			{
				if(bots[i].alpha == 0.7){
					bots[i].alpha = 1; 
				}
			}
			
		}
		
		
		public function clear():void
		{
			undo.removeEventListener(MouseEvent.CLICK,onUndo);
			done.removeEventListener(MouseEvent.CLICK,onDone);
			reset.removeEventListener(MouseEvent.CLICK,onReset);
			for (var i:int = 0; i < bots.length; i++) 
			{
				if(bots[i].alpha > 0.6 && bots[i].alpha < 0.8){
					bots[i].removeEventListener(MouseEvent.CLICK,onClick);
				}
			}
			
			
		}
		/**
		 *重置已升级的技能 
		 * @param event
		 * 
		 */
		protected function onReset(event:MouseEvent):void
		{
			playEffectSound();
			changeStar(starAll);
			initLv();
		}
		
		protected function onDone(event:MouseEvent):void
		{
			playEffectSound();
			TweenLite.to(this,0.3,{y:-500});
			clear();
		}
		
		protected function onUndo(event:MouseEvent):void
		{
			playEffectSound();
		}
		
		public function huanDong():void
		{
			init();
			this.y = -200;
			TweenLite.to(this,0.3,{y:230});
		}
		/**
		 *更改星星数量 
		 * @param num
		 * @return 
		 * 
		 */
		public function changeStar(num:int):void
		{
			starN = num;
			starNum.text = num.toString();
		}
		public function playEffectSound():void
		{
			SoundManager.getInstance().playEffectSound("mouseClick",1);
		}
	}
}