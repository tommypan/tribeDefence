package game.view.scene.ui.battle
{
	import com.gs.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import qmang2d.loader.LoaderManager;
	import qmang2d.utils.ClassManager;
	
	/**
	 *建筑地基 
	 * @author panhao
	 * 
	 */	
	public class BuildingBase extends Sprite
	{
		
		private var bitmap:Bitmap;
		private var bar   :MovieClip;
		
		public function BuildingBase(name:String,time:Number)
		{
			bitmap = new Bitmap(ClassManager.createBitmapDataInstance(name));
			addChild(bitmap);
			
			bar  = (ClassManager.createDisplayObjectInstance("bar") as MovieClip);
			addChild(bar);
			var w :Number = bar.width;
			bar.width = 0;
			bar.y = -5;
			bar.x =  15;
			
			TweenLite.to(bar,time,{width:w,onComplete:dispose});
			
		}
		
		private function dispose():void
		{
			this.parent.removeChild(this);
			bitmap.bitmapData.dispose();
			removeChild(bar);
			bar = null
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}