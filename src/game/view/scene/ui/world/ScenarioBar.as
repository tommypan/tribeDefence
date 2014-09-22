package game.view.scene.ui.world
{
	import com.gs.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.event.SceneChangeEvent;
	
	import lang.Drama;
	
	import qmang2d.loader.LoaderManager;
	import qmang2d.protocol.SoundManager;
	import qmang2d.utils.ClassManager;

	/**
	 *剧情面板 
	 * @author Star
	 */
	public class ScenarioBar extends Sprite
	{
		private var barMc:MovieClip;
		private var close:SimpleButton;
		private var juqing:TextField;
		private var fight:SimpleButton;
		private var mapName:TextField;
		private var miniPoint:MovieClip;
		private var map1:Bitmap;
		private var map2:Bitmap;
		private var map3:Bitmap;
		private var map4:Bitmap;
		private var map5:Bitmap;
		private var map6:Bitmap;
		private var map7:Bitmap;
		private var map8:Bitmap;
		private var map9:Bitmap;
		private var map10:Bitmap;
		private var map11:Bitmap;
		private var map12:Bitmap;
		private var mapContainer:Sprite;
		public function ScenarioBar()
		{
			map1 = new Bitmap(ClassManager.createBitmapDataInstance("miniMap1"));
			map2 = new Bitmap(ClassManager.createBitmapDataInstance("miniMap2"));
			map3 = new Bitmap(ClassManager.createBitmapDataInstance("miniMap3"));
			map4 = new Bitmap(ClassManager.createBitmapDataInstance("miniMap4"));
			map5 = new Bitmap(ClassManager.createBitmapDataInstance("miniMap5"));
			map6 = new Bitmap(ClassManager.createBitmapDataInstance("miniMap6"));
			map7 = new Bitmap(ClassManager.createBitmapDataInstance("miniMap7"));
			map8 = new Bitmap(ClassManager.createBitmapDataInstance("miniMap8"));
			map9 = new Bitmap(ClassManager.createBitmapDataInstance("miniMap9"));
			map10= new Bitmap(ClassManager.createBitmapDataInstance("miniMap10"));
			map11= new Bitmap(ClassManager.createBitmapDataInstance("miniMap11"));
			map12= new Bitmap(ClassManager.createBitmapDataInstance("miniMap12"));
			
			mapContainer = new Sprite();
			barMc = ClassManager.createInstance("mainMiniMap") as MovieClip;
			addChild(barMc);	
			juqing = barMc.juQing;
			fight = barMc.fight;
			close = barMc.mapClose;
			mapName = barMc.mapName;
			miniPoint = barMc.miniPoint;
			mapContainer.addChild(map1);
			addChild(mapContainer);
			mapContainer.x = miniPoint.x;
			mapContainer.y = miniPoint.y;
			fight.addEventListener(MouseEvent.CLICK,onFight);
			close.addEventListener(MouseEvent.CLICK,onClose);
		}
		
		protected function onFight(event:MouseEvent):void
		{
			huanDong1();
			SoundManager.getInstance().playEffectSound("mouseClick",1);
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.TO_BATTLE_SCENE));
		}
		
		protected function onClose(event:MouseEvent):void
		{
			SoundManager.getInstance().playEffectSound("mouseClick",1);
			huanDong1();
		}
		
		/**
		 *变更 关数 
		 * @param num 关数值
		 * 
		 */
		public function changeLv(num:int):void
		{
			if(num == 1){
				mapName.text = Drama.CHAP_TITLE1;
				juqing.text = Drama.CHAP1;
				mapContainer.removeChildAt(0);
				mapContainer.addChild(map1);
			}else if(num ==2){
				mapName.text= Drama.CHAP_TITLE2;
				juqing.text = Drama.CHAP2;
				mapContainer.removeChildAt(0);
				mapContainer.addChild(map2);
			}else if(num == 3){
				mapName.text= Drama.CHAP_TITLE3;
				juqing.text =Drama.CHAP3;
				mapContainer.removeChildAt(0);
				mapContainer.addChild(map3);
			}else if(num == 4){
				mapName.text= Drama.CHAP_TITLE4;
				juqing.text = Drama.CHAP4;
				mapContainer.removeChildAt(0);
				mapContainer.addChild(map4);
			}else if(num == 5){
				mapName.text= Drama.CHAP_TITLE5;
				juqing.text = Drama.CHAP5;
				mapContainer.removeChildAt(0);
				mapContainer.addChild(map5);
			}else if(num == 6){
				mapName.text= Drama.CHAP_TITLE6;
				juqing.text = Drama.CHAP6;
				mapContainer.removeChildAt(0);
				mapContainer.addChild(map6);
			}else if(num == 7){
				mapName.text= Drama.CHAP_TITLE7;
				juqing.text = Drama.CHAP7;
				mapContainer.removeChildAt(0);
				mapContainer.addChild(map7);
			}else if(num == 8){
				mapName.text= Drama.CHAP_TITLE8;
				juqing.text = Drama.CHAP8;
				mapContainer.removeChildAt(0);
				mapContainer.addChild(map8);
			}else if(num == 9){
				mapName.text= Drama.CHAP_TITLE9;
				juqing.text = Drama.CHAP9;
				mapContainer.removeChildAt(0);
				mapContainer.addChild(map9);
			}else if(num == 10){
				mapName.text= Drama.CHAP_TITLE10;
				juqing.text = Drama.CHAP10;
				mapContainer.removeChildAt(0);
				mapContainer.addChild(map10);
			}else if(num == 11){
				mapName.text= Drama.CHAP_TITLE11;
				juqing.text = Drama.CHAP11;
				mapContainer.removeChildAt(0);
				mapContainer.addChild(map11);
			}else if(num == 12){
				mapName.text= Drama.CHAP_TITLE12;
				juqing.text = Drama.CHAP12;
				mapContainer.removeChildAt(0);
				mapContainer.addChild(map12);
			}else{
				juqing.text = "资金未到，演员未定，剧本暂无";
			}
			
		}
		
		public function huanDong():void
		{
			this.visible = true;
			TweenLite.to(this,1,{alpha:1,y:250});
		}
		public function huanDong1():void
		{
			TweenLite.to(this,0.3,{alpha:0,y:200,onComplete: onFinishTween});
		}
		private function onFinishTween():void
		{
			this.visible = false;
		}
	}
}