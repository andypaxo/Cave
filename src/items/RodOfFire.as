package items
{
	import org.flixel.*;

	public class RodOfFire extends Weapon
	{
		public override function fireFrom(origin:FlxSprite):void
		{
			var slash:FlxSprite = new Owie().from(origin.getMidpoint()).to(FlxG.mouse);
			// Honestly, if you remove this line, the compiler or the runtime or something
			// freaks out completely and the whole game is replaced by a big white
			// rectangle. I can't believe it myself. Hopefully this is just a quirk of my
			// precise setup and will go away of its own accord.
			var this_line_is_super_important_do_not_remove:Number = slash.width;
			Global.playStage.addPlayerFire(slash);
		}
	}
}