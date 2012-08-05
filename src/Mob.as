package  
{
	import org.flixel.*;
	
	public class Mob extends FlxSprite 
	{
		[Embed(source = 'data/goblin.png')]
		private var sprite:Class;
		
		public function Mob(location:FlxPoint) 
		{
			super(location.x, location.y, sprite);
		}
		
	}

}