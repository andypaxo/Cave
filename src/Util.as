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
		
		public static function subtract(a:FlxPoint, b:FlxPoint):FlxPoint {
			return new FlxPoint(a.x - b.x, a.y - b.y);
		}
		
		public static function normalize(point:FlxPoint, scale:Number = 1):FlxPoint {
			if (point.x == 0 && point.y == 0)
				return point;
				
			var magnitude:Number = FlxU.getDistance(new FlxPoint(), point);
			return new FlxPoint(scale * point.x / magnitude, scale * point.y / magnitude);
		}
		
		public static function randomItemFrom(items:Array):Object {
			return items[Math.floor(Math.random() * items.length)];
		}
		
		public static function contains(bounds:FlxRect, point:FlxPoint):Boolean {
			return point.x >= bounds.left && point.x <= bounds.right && point.y >= bounds.top && point.y <= bounds.bottom;
		}
	}

}