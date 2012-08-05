package  
{
	import org.flixel.*;
	
	public class HealthBar extends FlxSprite 
	{
		[Embed(source = 'data/heartFull.png')]
		private var fullSprite:Class;
		[Embed(source = 'data/heartEmpty.png')]
		private var emptySprite:Class;
		
		private const iconSize:int = 8;
		
		private var full:FlxSprite;
		private var empty:FlxSprite;
		
		public function HealthBar() 
		{
			super(2, 2);
			makeGraphic(iconSize * Player.maxHealth, iconSize, 0);
			scrollFactor = new FlxPoint();
			
			full = new FlxSprite(0, 0, fullSprite);
			empty = new FlxSprite(0, 0, emptySprite);
		}
		
		override public function update():void 
		{
			super.update();
			pixels.fillRect(pixels.rect, 0);
			for (var i:int = 0; i < Player.maxHealth; i++) 
				stamp(Global.player.health > i ? full : empty, i * iconSize, 0);
		}
		
	}

}