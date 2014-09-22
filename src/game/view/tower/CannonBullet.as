package game.view.tower
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import qmang2d.display.BitmapMovie;
	import qmang2d.loader.LoaderManager;
	import qmang2d.protocol.LayerCollection;
	import qmang2d.utils.ClassManager;
	
	/**
	 * 
	 * @author panhao
	 * @date 2013-8-3
	 */	
	public class CannonBullet extends Sprite
	{
		public var mc:BitmapMovie;
		public function CannonBullet()
		{
			var bulletMc :MovieClip = ClassManager.createDisplayObjectInstance("bullet1") as MovieClip;
			mc = LoaderManager.getInstance().changeMcToBitmapMovie(bulletMc,true,"bullte1");
			addChild(mc);//层次在effectLayer
			this.visible = false;
			
		}
		
		public function updateXY():void
		{
			mc.x = -mc.width/2;mc.y = -mc.height/2;
		}
	}
}