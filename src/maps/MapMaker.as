package maps
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.*;
	import mobs.*;
	
	public class MapMaker 
	{
		private const maxPlacedItems:int = 100;
		private const placeableBorder:int = 2;

		protected var mapWidth:int;
		protected var mapHeight:int;

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
		
		public function makeMobs():FlxGroup
		{
			var result:FlxGroup = new FlxGroup(maxPlacedItems);
			
			var placeableArea:FlxRect = new FlxRect(
				placeableBorder, placeableBorder, 
				mapWidth - placeableBorder * 2, mapHeight - placeableBorder * 2);
				
			for (var i:int = 0; i < maxPlacedItems; i++) 
			{
				var tileLocation:FlxPoint = new FlxPoint(
					Math.floor(Math.random() * placeableArea.width + placeableArea.left),
					Math.floor(Math.random() * placeableArea.height + placeableArea.top));
					
				if (tilemap.getTile(tileLocation.x, tileLocation.y) == 0)
					addMob(tileLocation, result);
				else
					tilemap.setTile(tileLocation.x, tileLocation.y, Global.gemTile);
			}
			
			return result;
		}
		
		private function addMob(location:FlxPoint, group:FlxGroup):void {
			var pixelLocation:FlxPoint = Util.scalePoint(location, Global.tileSize);
			if (FlxU.getDistance(pixelLocation, Global.player.getMidpoint()) > 16 * tileSize)
				group.add(new (Util.randomItemFrom(enemyTypes))(pixelLocation));
		}

		protected function placeHoleAt(location:FlxPoint):void
		{
			var pixelLocation:FlxPoint = Util.scalePoint(location, Global.tileSize);
			var hole:FlxSprite = new Hole(pixelLocation);
			itemsGroup.add(hole);
		}

		protected function placeChestAt(location:FlxPoint):void
		{
			var pixelLocation:FlxPoint = Util.scalePoint(location, Global.tileSize);
			var chest:FlxSprite = new Chest(pixelLocation);
			itemsGroup.add(chest);
		}

		protected function addImpassableBorderTo(tilemap:FlxTilemap):void {
			for (var cx:int = 0; cx < mapWidth; cx ++)
			{
				tilemap.setTile(cx, 0, Global.graniteTile);
				tilemap.setTile(cx, mapHeight - 1, Global.graniteTile);
			}

			for (var cy:int = 0; cy < mapHeight; cy ++)
			{
				tilemap.setTile(0, cy, Global.graniteTile);
				tilemap.setTile(mapWidth - 1, cy, Global.graniteTile);
			}
		}

		protected function makeRocksPretty(tilemap:FlxTilemap):void {
			for (var cx:int = 0; cx < mapWidth; cx ++)
				for (var cy:int = 0; cy < mapHeight - 1; cy ++)
				{
					if (tilemap.getTile(cx, cy) == Global.rockTile && tilemap.getTile(cx, cy + 1) == Global.floorTile)
						tilemap.setTile(cx, cy, Global.rockTile2);
					if (tilemap.getTile(cx, cy) == Global.wallTile && tilemap.getTile(cx, cy + 1) == Global.floorTile)
						tilemap.setTile(cx, cy, Global.wallTile2);
				}
		}
	}

}