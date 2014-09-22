package game.view.scene.ui.world
{
	import com.gs.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;

	/**
	 * 激活面板
	 * @author Star
	 * 
	 */
	public class JihuoBar extends Sprite
	{
		private var jiHuo:MovieClip;
		private var moreMoney:SimpleButton;
		private var lightning:SimpleButton;
		private var yuanJUn:SimpleButton;
		
		private var skin1:SimpleButton;
		private var skin2:SimpleButton;
		private var skin3:SimpleButton;
		private var skin4:SimpleButton;
		private var close:SimpleButton;
		private var lastSkin:int;
		private var skins:Vector.<SimpleButton> = new Vector.<SimpleButton>();
		public function JihuoBar()
		{
			jiHuo = ClassManager.createInstance("baiJinBar") as MovieClip;
			addChild(jiHuo);
			
			moreMoney = jiHuo.bot1;
			lightning = jiHuo.bot2;
			yuanJUn  = jiHuo.bot3;
			skin1 = jiHuo.bot4;
			skin2 = jiHuo.bot5;
			skin3 = jiHuo.bot6;
			skin4 = jiHuo.bot7;
			close = jiHuo.bot8;
			skins.push(skin1);skins.push(skin2);skins.push(skin3);skins.push(skin4);
			lastSkin = 0;
			skin2.alpha = skin3.alpha = skin4.alpha = 0;
		}
		public function init():void
		{
			moreMoney.addEventListener(MouseEvent.CLICK,onMoney);
			lightning.addEventListener(MouseEvent.CLICK,onLightning);
			yuanJUn.addEventListener(MouseEvent.CLICK,onYuanJun);
			close.addEventListener(MouseEvent.CLICK,onClose);
			skin1.addEventListener(MouseEvent.CLICK,onChangeSkin);
			skin2.addEventListener(MouseEvent.CLICK,onChangeSkin);
			skin3.addEventListener(MouseEvent.CLICK,onChangeSkin);
			skin4.addEventListener(MouseEvent.CLICK,onChangeSkin);
			
		}
		public function clear():void
		{
			moreMoney.removeEventListener(MouseEvent.CLICK,onMoney);
			lightning.removeEventListener(MouseEvent.CLICK,onLightning);
			yuanJUn.removeEventListener(MouseEvent.CLICK,onYuanJun);
			close.removeEventListener(MouseEvent.CLICK,onClose);
			skin1.removeEventListener(MouseEvent.CLICK,onChangeSkin);
			skin2.removeEventListener(MouseEvent.CLICK,onChangeSkin);
			skin3.removeEventListener(MouseEvent.CLICK,onChangeSkin);
			skin4.removeEventListener(MouseEvent.CLICK,onChangeSkin);
		}
		
		protected function onClose(event:MouseEvent):void
		{
			playEffectSound();
			TweenLite.to(this,0.3,{y:-500});
			clear();
		}
		protected function onChangeSkin(event:MouseEvent):void
		{
			playEffectSound();
			var skinId:String = event.target.name;
			if(skinId == "bot4"){
				skins[lastSkin].alpha = 0;
				lastSkin = 0;
				skin1.alpha = 1;
			}else if(skinId == "bot5"){
				skins[lastSkin].alpha = 0;
				lastSkin = 1;
				skin2.alpha = 1;
			}else if(skinId == "bot6"){
				skins[lastSkin].alpha = 0;
				lastSkin = 2;
				skin3.alpha = 1;
			}else if(skinId == "bot7"){
				skins[lastSkin].alpha = 0;
				lastSkin = 3;
				skin4.alpha = 1;
			}
		}
		
		protected function onYuanJun(event:MouseEvent):void
		{
			playEffectSound();
			if(yuanJUn.alpha == 1)
				yuanJUn.alpha = 0;
			else
				yuanJUn.alpha = 1;
		}
		
		protected function onLightning(event:MouseEvent):void
		{
			playEffectSound();
			if(lightning.alpha == 1)
				lightning.alpha = 0;
			else
				lightning.alpha = 1;
		}
		
		protected function onMoney(event:MouseEvent):void
		{
			playEffectSound();
			if(moreMoney.alpha == 1)
				moreMoney.alpha = 0;
			else
				moreMoney.alpha = 1;
		}
		public function huanDong():void
		{
			init();
			this.y = -200;
			TweenLite.to(this,0.3,{y:230});
		}
		public function playEffectSound():void
		{
			SoundManager.getInstance().playEffectSound("mouseClick",1);
		}
	}
}