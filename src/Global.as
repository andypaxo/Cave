package  
{
	import org.flixel.*;
	
	public class Global 
	{
		public static const tileSize:int = 10;
		public static var player:Player;
		public static var world:World;
		
		private static var cooldowns:Vector.<Cooldown> = new Vector.<Cooldown>();
		
		public static function createCooldown(callback:Function, thisArg:Object, length:Number):Cooldown
		{
			var result = new Cooldown(callback, thisArg, length);
			cooldowns.push(result);
			return result;
		}
		
		public static function removeCooldown(cooldown:Cooldown):void
		{
			var index:int = cooldowns.indexOf(cooldown);
			cooldowns.splice(index, 1);
		}
		
		public static function update():void
		{
			for each (var cooldown:Cooldown in cooldowns) {
				cooldown.timeElapsed(FlxG.elapsed);
			}
		}
	}

}