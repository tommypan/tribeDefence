package game.view.scene.ui.world
{
	import qmang2d.utils.ClassManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	/**
	 *路点牌
	 * <p>请在加载完世界地图后进行实例化 
	 * <p>在本游戏中只有一个实例，故设为单例
	 * @author panhao
	 * 
	 */	
	public class PathNode extends Sprite
	{
		private static var _instance :PathNode;
		
		private var _node :MovieClip;
		private var _glow :GlowFilter;
		
		public function PathNode(sin :singltonEnforcer)
		{
			if(sin == null)
			{
				throw new Error("this is a singlton");
			}else{
				_node = ClassManager.createInstance("nodeMc") as MovieClip;
				_node.mouseChildren = false;
				_node.gotoAndStop(2);
				addChild(_node);
				
				_glow = new GlowFilter();
				_glow.color = 0xffff00;
				_node.buttonMode = true;
				_node.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				_node.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			}
		}
		
		public static function getInstance():PathNode
		{
			_instance ||= new PathNode(new singltonEnforcer());
			return _instance;
		}
		
		
		private function onOut(event:MouseEvent):void
		{
			_node.filters = [];
		}
		
		private function onOver(event:MouseEvent):void
		{
			_node.filters = [_glow];
		}
		
		
	}
}
class singltonEnforcer
{
	
}