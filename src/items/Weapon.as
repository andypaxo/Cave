package items
{
	import org.flixel.*;

	public class Weapon
	{
		public var sprite:FlxSprite;
		public var uses:Number = 100;
		public var maxUses:Number = 100;

		public function Weapon(graphic:Class)
		{
			sprite = new FlxSprite(0, 0, graphic);
		}

		public function fireFrom(origin:FlxSprite):void
		{

		}
	}
}