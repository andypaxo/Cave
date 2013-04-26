package mobs
{
	import org.flixel.*

	public class Goblin extends Mob
	{
		[Embed(source = '../data/goblin.png')]
		private var sprite:Class;

		public function Goblin(location:FlxPoint,graphic:Class=null) 
		{
			super(location, sprite);
			setup();
		}
	}
}