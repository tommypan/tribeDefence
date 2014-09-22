package game.event
{
	
	/**
	 * 
	 * @author panhao
	 * @date 2013-8-1
	 */	
	public class TowerEvent extends GameEvent
	{
		/**
		 *大炮一 ,通信发送的数据
		 */		
		public static const CANNON1 :String = "cannon1";
		
		/**
		 *兵营一 ,通信发送的数据
		 */		
		public static const SHIELD1 :String = "shield1";
		
		/**
		 *魔法一 ,通信发送的数据
		 */		
		public static const MAGIC1  :String = "magic1";
		
		/**
		 *剑灵一 ,通信发送的数据
		 */		
		public static const ARROW1  :String = "arrow1";
		
		/**
		 *大炮2 ,通信发送的数据
		 */		
		public static const CANNON2 :String = "cannon2";
		
		/**
		 *兵营2 ,通信发送的数据
		 */		
		public static const SHIELD2 :String = "shield2";
		
		/**
		 *魔法2 ,通信发送的数据
		 */		
		public static const MAGIC2  :String = "magic2";
		
		/**
		 *剑灵2 ,通信发送的数据
		 */		
		public static const ARROW2  :String = "arrow2";
		
		/**
		 *大炮3 ,通信发送的数据
		 */		
		public static const CANNON3 :String = "cannon3";
		
		/**
		 *兵营3 ,通信发送的数据
		 */		
		public static const SHIELD3 :String = "shield3";
		
		/**
		 *魔法3 ,通信发送的数据
		 */		
		public static const MAGIC3  :String = "magic3";
		
		/**
		 *剑灵3 ,通信发送的数据
		 */		
		public static const ARROW3  :String = "arrow3";
		
		/**
		 *大炮4 ,通信发送的数据
		 */		
		public static const CANNON4 :String = "cannon4";
		
		/**
		 *兵营4 ,通信发送的数据
		 */		
		public static const SHIELD4 :String = "shield4";
		
		/**
		 *魔法4,通信发送的数据
		 */		
		public static const MAGIC4  :String = "magic4";
		
		/**
		 *剑灵4 ,通信发送的数据
		 */		
		public static const ARROW4  :String = "arrow4";
		
		/**
		 *第一次塔防升级 
		 */		
		public static const UPDATE :String = "update";
		
		/**
		 *射击结束
		 */		
		public static const SHOOT_OVER :String = "shootOver";
		
		/**
		 *射击结束
		 */		
		public static const START_SHOOT :String = "startShoot";
		
		public function TowerEvent(type:String,data_:Object = null)
		{
			super(type,data_);
		}
	}
}