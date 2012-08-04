package  
{
	import org.flixel.*;
	
	public class Util 
	{
		
		public static function addPoints(a:FlxPoint, b:FlxPoint):FlxPoint {
			return new FlxPoint(a.x + b.x, a.y + b.y);
		}
		
		public static function scalePoint(point:FlxPoint, scale:Number):FlxPoint {
			return new FlxPoint(point.x * scale, point.y * scale);
		}
	}

}