package  
{
	import org.flixel.*;
	
	public class Mess extends FlxSprite
	{
		[Embed(source = 'data/mess.png')]
		private var messSprite:Class;
		
		public function Mess(X:Number=0,Y:Number=0) 
		{
			super(X, Y);
			loadGraphic(messSprite, true);
			frame = Math.floor(Math.random() * frames);
		}
		
	}

}