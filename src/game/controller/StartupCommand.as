package game.controller
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	
	/** 
	 * 启动程序，启动socket（TCP）连接；
	 * @author pengbinke
	 * <p> 2013-3-7 下午2:36:20
	 */
	public class StartupCommand extends Command
	{
		
		public function StartupCommand(){}
		
		override public function execute():void
		{
			
//			//成功获取用户帐号、密码和服务器的IP和端口号，开始连接服务器
//			commandMap.mapEvent(GameInitializeEvent.CONNECT_COMPLETE, InitCommand, Event, true);
//			
//			commandMap.mapEvent(GameInitializeEvent.RECEIVE_ACCOUNT_VALIDATION,RecieveAccountCommand,ReceiveEvent);
//			socketServer.connect("127.0.0.1",8888);
			//初始化获取Socket配置数据
		}
		
		
		
	}
}