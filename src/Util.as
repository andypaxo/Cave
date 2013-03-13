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
				
			var magnitude:Number = length(point);
        	return multiply(point, scale/magnitude);
		}

        public static function multiply(v:FlxPoint, amt:Number):FlxPoint {
        	return new FlxPoint(v.x*amt, v.y*amt);
        }

    	public static function length(v:FlxPoint):Number {
        	return Math.sqrt(v.x*v.x+v.y*v.y);
        }
		
		public static function randomItemFrom(items:Array):Object {
			return items[Math.floor(Math.random() * items.length)];
		}
		
		public static function contains(bounds:FlxRect, point:FlxPoint):Boolean {
			return point.x >= bounds.left && point.x <= bounds.right && point.y >= bounds.top && point.y <= bounds.bottom;
		}
	}

}