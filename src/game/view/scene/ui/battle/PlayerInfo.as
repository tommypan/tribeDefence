package game.view.scene.ui.battle
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.text.TextField;
	
	import qmang2d.loader.LoaderManager;
	import qmang2d.utils.ClassManager;
	
	public class PlayerInfo extends Sprite
	{
		private static var  _instance :PlayerInfo;
		
		private var mainMc:MovieClip;
		private var live:TextField;
		private var money:TextField;
		private var wave:TextField;
		public function PlayerInfo(singlton:SingltonEnforcer)
		{
			if(!singlton)
			{
				throw new IllegalOperationError(" this is a singlton");
			}else{
				
				mainMc = ClassManager.createInstance("mainLive") as MovieClip;
				addChild(mainMc);
				live = mainMc.txtLives;
				money = mainMc.money;
				wave = mainMc.txtWaves;
			}
		
		}
		
		public static function getInstance():PlayerInfo
		{
			_instance ||= new PlayerInfo(new SingltonEnforcer());
			return _instance;
		}
		
		public function updataMoney(money:int):void{
			this.money.text = money.toString();
		}
		
		public function updataLive(live:int):void{
			this.live.text = live.toString();
			
		}
		
		public function upDateWave(cur:int,total:int):void
		{
			this.wave.text = "波数: "+cur+" / "+total;
		}
		
	}
}
internal class SingltonEnforcer{}