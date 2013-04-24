package items
{
	import org.flixel.*;

	public class Dagger extends Weapon
	{
		[Embed(source = '../data/slash.png')]
		private var slashGraphic:Class;

		[Embed(source = '../data/item-dagger.png')]
		private var _graphic:Class;

		public function Dagger()
		{
			super(_graphic);
		}

		public override function fireFrom(origin:FlxSprite):void
		{
			var midpoint:FlxPoint = origin.getMidpoint();
			var corner:FlxPoint = new FlxPoint(origin.x + 2, origin.y + 2);
			var location:FlxPoint = Util.addPoints(
				corner,
				Util.normalize(Util.subtract(FlxG.mouse, corner), origin.width * 1.5));
			
			var slash:Owie = new Owie(0,0,null,0.2).from(location).follow(origin);
			slash.loadGraphic(slashGraphic, true, false, 10);
			slash.addAnimation('default', [0, 1, 2, 3, 4, 5], 30);
			slash.play('default');
			slash.damage = 2;
			slash.killOnContact = false;

			slash.angle = Util.angleFromPoint(midpoint, FlxG.mouse);
			Global.playStage.addPlayerFire(slash);
		}
	}
}