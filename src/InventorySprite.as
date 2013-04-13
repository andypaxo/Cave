package
{
	import org.flixel.*;
	import items.*;
	import flash.geom.Rectangle;

	public class InventorySprite extends FlxSprite
	{
		[Embed(source = 'data/inventory-slot.png')]
		private var slot_graphic:Class;
		[Embed(source = 'data/inventory-slot-selected.png')]
		private var selected_graphic:Class;

		private var slot:FlxSprite = new FlxSprite(0, 0, slot_graphic);
		private var selected:FlxSprite = new FlxSprite(0, 0, selected_graphic);
		private const iconSize:Number = 16;

		public function InventorySprite()
		{
			var w:Number = iconSize * Global.player.inventory.length;
			super((FlxG.width - w) / 2, FlxG.height - iconSize);
			makeGraphic(w, 16);
			scrollFactor = new FlxPoint();
		}

		override public function update():void 
		{
			super.update();
			var player:Player = Global.player;
			var inventory:Array = player.inventory;
			pixels.fillRect(pixels.rect, 0);
			for (var i:Number = 0; i < inventory.length; i++)
			{
				stamp(i == player.wieldedIndex ? selected : slot, i * iconSize, 0);
				if (inventory[i])
				{
					var weapon:Weapon = Weapon(inventory[i]);
					stamp(weapon.sprite, i * iconSize, 0);
					var usesRemaining:Number = weapon.uses / weapon.maxUses;
					if (usesRemaining < 1)
						pixels.fillRect(
							new Rectangle(i * iconSize + 1, 12, usesRemaining * (iconSize - 2), 2),
							0xff00ff00);
				}
			}
		}
	}
}