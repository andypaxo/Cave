package  
{
	import org.flixel.*;
	
	public class Owie extends FlxSprite
	{
		[Embed(source = 'data/owie.png')]
		private var sprite:Class;
		
		private var end:Cooldown;
		
		public function Owie(x:Number, y:Number) 
		{
			super(x, y);
			loadGraphic(sprite, true);
			addAnimation('default', [0, 1, 2, 3], 30);
			play('default');
			end = Global.createCooldown(kill, this, 0.3);
			end.reset();
		}
		
		override public function update():void 
		{
			super.update();
			end.execute();
		}
		
		override public function kill():void 
		{
			super.kill();
			Global.removeCooldown(end);
		}
	}

}