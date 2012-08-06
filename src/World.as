package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.*;
	
	public class World 
	{
		[Embed(source = 'data/terrain.png')]
		private var terrainSprite:Class;
		
		private const maxPlacedItems:int = 100;
		private const placeableBorder:int = 2;
		private const mapWidth:int = 150;
		private const mapHeight:int = 150;
		private const roomFrequency:Number = 0.6;
		public var tileSize:int;
		
		private var tilemap:FlxTilemap;
		
		public function World() 
		{
			var noiseBitmap:BitmapData = makeSomeNoise();
			tilemap = makeTilemapFrom(noiseBitmap);
			tileSize = tilemap.width / tilemap.widthInTiles;
		}
		
		public function getTilemap():FlxTilemap {
			return tilemap;
		}
		
		private function makeSomeNoise():BitmapData
		{
			var noiseBitmap:BitmapData = new BitmapData(mapWidth, mapHeight, false, 0xffffffff);
			var mapBitmap:BitmapData = new BitmapData(mapWidth, mapHeight, false, 0xff000000);
			noiseBitmap.perlinNoise(16, 16, 5, Math.random() * 64000, false, false, 7, true);
			var rockThreshold:uint = 0xff000044;
			var gemsThreshold:uint = 0xff000066;
			mapBitmap.threshold(noiseBitmap, noiseBitmap.rect, new Point(), ">", rockThreshold, 0xff888888, 0xff0000ff);
			// Would be nice if we could actually use this
			mapBitmap.threshold(noiseBitmap, noiseBitmap.rect, new Point(), ">", gemsThreshold, 0xffffffff, 0xff0000ff);
			return mapBitmap;
		}
		
		private function makeTilemapFrom(tileData:BitmapData):FlxTilemap {
			var mapData:String = FlxTilemap.bitmapToCSV(tileData);
			
			var result:FlxTilemap = new FlxTilemap();
			result.loadMap(mapData, terrainSprite, 0, 0, FlxTilemap.OFF, 0, 0);
			addRoomsTo(result);
			return result;
		}
		
		private function addRoomsTo(map:FlxTilemap):void {
			for (var x:int = 10; x < mapWidth - 10; x += 20)
				for (var y:int = 10; y < mapHeight - 10; y += 20)
					if (Math.random() < roomFrequency)
						placeRoom(map, x, y);
		}
		
		private function placeRoom(map:FlxTilemap, x:int, y:int):void {
			for (var cx:int = 0; cx < 9; cx ++)
				for (var cy:int = 0; cy < 9; cy ++)
					map.setTile(cx + x, cy + y, ((cx == 0 || cx == 8 || cy == 0 || cy == 8) && !(cx == 4 || cy == 4)) ? 3 : 0);
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
					tilemap.setTile(tileLocation.x, tileLocation.y, 2);
			}
			
			return result;
		}
		
		private function addMob(location:FlxPoint, group:FlxGroup):void {
			var pixelLocation:FlxPoint = Util.scalePoint(location, Global.tileSize);
			if (FlxU.getDistance(pixelLocation, Global.player.getMidpoint()) > 16 * tileSize)
				group.add(new Mob(pixelLocation));
		}
		
		private function indexToLocation(index:int):FlxPoint
		{
			return new FlxPoint((index % mapWidth), Math.floor(index / mapWidth));
		}
	}

}