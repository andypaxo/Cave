package maps
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.*;
	
	public class MapMaker 
	{
		[Embed(source = '../data/terrain.png')]
		protected var terrainSprite:Class;
		protected const enemyTypes:Array = [Goblin, Goblin, Mage];
		
		protected var tilemap:FlxTilemap;
		protected var itemsGroup:FlxGroup;
		
		public var tileSize:int;
		
		public function MapMaker(itemGroup:FlxGroup) 
		{
			this.itemsGroup = itemGroup;
		}
		
		public function getTilemap():FlxTilemap {
			return tilemap;
		}

		public function makeMobs():FlxGroup {
			return null;
		}
	}

}