package  
{
	public class Cooldown 
	{
		private var callback:Function;
		private var length:Number;
		private var thisArg:Object;
		private var timeRemaining:Number = 0;
		
		public function Cooldown(callback:Function, thisArg:Object, length:Number) 
		{
			this.callback = callback;
			this.length = length;
			this.thisArg = thisArg;
		}
		
		public function timeElapsed(elapsed:Number):void
		{
			timeRemaining -= elapsed;
		}
		
		public function execute():Object
		{
			if (timeRemaining <= 0)
			{
				reset();
				return callback.apply(thisArg, arguments);
			}
			return null;
		}
		
		public function reset():void
		{
			timeRemaining = length;
		}
	}

}