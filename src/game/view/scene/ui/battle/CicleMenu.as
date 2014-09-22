package game.view.scene.ui.battle
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import flashx.textLayout.operations.MoveChildrenOperation;
	
	import qmang2d.utils.ClassManager;
	
	/**
	 * 
	 * @author panhao
	 * @date 2013-8-14
	 */	
	public class CicleMenu extends Sprite
	{

		public var upgradeBtn:MovieClip;
		public var sellBtn:MovieClip;
		
		private var moneyText :TextField;
		private var fullLevel:MovieClip;
		private var upTowerCicle:MovieClip;
		public var arrow:SimpleButton;
		public var shield:SimpleButton;
		public var magic:SimpleButton;
		public var cannon:SimpleButton;

		private var _cicle:MovieClip;
		
		private var _lock1 :MovieClip;
		private var _lock2 :MovieClip;
		private var _lock3 :MovieClip;
		private var _lock4 :MovieClip;
		private var _upGradeLock :MovieClip;
		
		
		public function CicleMenu()
		{
			
		}
		
		public function initTower():void
		{
			_cicle = ClassManager.createInstance("cicle") as MovieClip;
			addChild(_cicle);
			arrow  = _cicle.arrow;
			shield = _cicle.shield;
			magic  = _cicle.magic;
			cannon = _cicle.cannon;
			
			
			_lock1 = _cicle.lock1;
			_lock2 = _cicle.lock2;
			_lock3 = _cicle.lock3;
			_lock4 = _cicle.lock4;
			_lock1.visible = false;
			_lock2.visible = false;
			_lock3.visible = false;
			_lock4.visible = false;
			
			_cicle.x = 35;_cicle.y = 25;
			
			
			if(upTowerCicle && contains(upTowerCicle))
			{
				(removeChild(upTowerCicle));
			}
		}
		
		public function checkMoneyEnough(money:int):void
		{
			if(money < 70)
			{
				_lock1.visible = true;
				_lock2.visible = true;
				_lock3.visible = true;
				_lock4.visible = true;
			}else if (money >= 70 && money < 100){
				_lock1.visible = false;
				_lock2.visible = false;
				_lock3.visible = true;
				_lock4.visible = true;
			}else if(money >= 100 && money < 150){
				_lock1.visible = false;
				_lock2.visible = false;
				_lock3.visible = false;
				_lock4.visible = true;
			}else{
				_lock1.visible = false;
				_lock2.visible = false;
				_lock3.visible = false;
				_lock4.visible = false;
			}
		}
		
		public function initUpGrade():void
		{
			(contains(_cicle)) && (removeChild(_cicle));
			
			upTowerCicle = ClassManager.createInstance("upTowerCicle") as MovieClip;
			addChild(upTowerCicle);
			upTowerCicle.x = 35; upTowerCicle.y = 10;
			
			upgradeBtn = ClassManager.createInstance("UpgradeBtn") as MovieClip;
			upTowerCicle.addChild(upgradeBtn);
			upgradeBtn.buttonMode = true;
			upgradeBtn.y = -60;
			moneyText = upgradeBtn.moneyText;
			
			sellBtn = ClassManager.createInstance("SellBtn") as MovieClip;
			upTowerCicle.addChild(sellBtn);
			sellBtn.buttonMode = true;
			sellBtn.y = 60;
			
			fullLevel = ClassManager.createInstance("FullLevelBtn") as MovieClip;
			upTowerCicle.addChild(fullLevel);
			fullLevel.visible = false;
			fullLevel.y = -60;
			
			_upGradeLock = ClassManager.createDisplayObjectInstance("LockBtn") as MovieClip;
			upTowerCicle.addChild(_upGradeLock);
			_upGradeLock.visible = false;
			_upGradeLock.y = -60;
		}
		
		
		public function setMoney(value :int):void
		{
			moneyText.text = String(value);
		}
		
		public function canGrade():void
		{
			fullLevel.visible = false;
			_upGradeLock.visible = false;
		}
		
		public function canNotGrade():void
		{
			fullLevel.visible = false;
			_upGradeLock.visible = true;
		}
		
		public function fullGrade():void
		{
			fullLevel.visible = true;
			_upGradeLock.visible = false;
		}
		
		public function dispose():void
		{
			if(upTowerCicle && contains(upTowerCicle))
			{
				(removeChild(upTowerCicle));
			}
			
			if(_cicle && contains(_cicle)) 
			{
				(removeChild(_cicle));
			}
		}
	}
}