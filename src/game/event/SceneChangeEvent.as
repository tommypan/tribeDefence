package game.event
{
	import flash.events.Event;

	public class SceneChangeEvent extends GameEvent
	{
		
		/**到登录界面 */
		public static const TO_LOGIN_SCENE:String = "TO_LOGIN_SCENE";
		/**到主界面 */
		public static const TO_MIAN_SCENE:String = "TO_MIAN_SCENE";
		/**返回主界面*/
		public static const BACK_MAIN_SCENE:String = "BACK_MAIN_SCENE";
		/**进入世界界面 */
		public static const TO_WORLD_SCENE:String = "TO_WORLD_SCENE"; 
		/**返回世界*/
		public static const BACK_WORLD_SCENE:String = "BACK_WORLD_SCENE";
		/**进入战斗界面*/
		public static const TO_BATTLE_SCENE:String = "TO_BATTLE_SCENE";
		/**第一次进入战斗界面*/
		public static const FIRST_TO_BATTLE_SCENE:String = "FIRST_TO_BATTLE_SCENE";
//		/**返回战斗*/
//		public static const BACK_BATTLE_SCENE:String = "BACK_BATTLE_SCENE";
		
	
		
		public function SceneChangeEvent(type:String,data_:Object = null)
		{
			//data_ && (data=data_);
			super(type,data_);
		}
	}
}