package event
{
	import flash.events.Event;
	
	public class DataChanged extends Event
	{
		/**
		 *数据列表变化 
		 */		
		public static const RefreshData:String = "refreshdata";
		public function DataChanged(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}