package maps
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.*;
	
	public class Catacombs extends MapMaker 
	{
		private var map:Array = [];

		public function Catacombs(itemGroup:FlxGroup)
		{
			super(itemGroup);
			mapWidth = 80;
			mapHeight = mapWidth;
			tilemap = makeTilemap();
			tileSize = tilemap.width / tilemap.widthInTiles;
		}

		private function makeTilemap():FlxTilemap
		{
			// Fill map solid
			for (var n:int = 0; n < mapWidth * mapHeight; n++)
				map.push(Global.rockTile);

			// Choose room locations
			var rooms:Array = [];
			rooms.push(new FlxPoint(int(mapWidth / 2), int(mapHeight / 2)));
			var numRooms:int = 18;
			for (n = 0; n < numRooms; n++)
				rooms.push(new FlxPoint(
					int(Math.random() * (mapWidth - 10) + 5),
					int(Math.random() * (mapHeight - 10) + 5)));
			
			rooms.forEach(drawRoom);

			drawCorridorsBetween(rooms);

			var mapData:String = FlxTilemap.arrayToCSV(map, mapWidth);
			var result:FlxTilemap = new FlxTilemap();
			result.loadMap(mapData, terrainSprite, 0, 0, FlxTilemap.OFF, 0, 0);
			makeRocksPretty(result);
			addImpassableBorderTo(result);
			return result;
		}

		private function drawRoom(location:FlxPoint, index:int, dontcare2:Object):void
		{
			var roomWidth:int = Math.floor(Math.random() * 4) + 3;
			var roomHeight:int = Math.floor(Math.random() * 4) + 3;
			var x:int, y:int;

			for (x = location.x - roomWidth; x < location.x + roomWidth; x++)
			{
				printWall(x, location.y - roomHeight - 1);
				printWall(x, location.y + roomHeight);

				for (y = location.y - roomHeight; y < location.y + roomHeight; y++)
					map[y * mapWidth + x] = Global.floorTile;
			}


			for (y = location.y - roomHeight; y < location.y + roomWidth; y++)
			{
				printWall(location.x - roomWidth - 1, y);
				printWall(location.x + roomWidth, y);
			}

			if (index > 0) {
				var rnd:Number = Math.random();
				if (rnd < 0.3)
					placeHoleAt(location);
				else if (rnd < 0.7)
					placeChestAt(location);
			}
		}

		private function drawCorridorsBetween(rooms:Array):void
		{
			var lastPoint:FlxPoint = rooms[0];
			for (var roomN:int in rooms)
			{
				var room:FlxPoint = rooms[roomN];
				drawCorridor(room, lastPoint);
				lastPoint = room;
			}
		}

		private function drawCorridor(a:FlxPoint, b:FlxPoint):void
		{
			var to:int, from:int, x:int, y:int;
			from = Math.min(a.x, b.x);
			to = Math.max(a.x, b.x);
			for (x = from; x < to; x++)
			{
				map[a.y * mapWidth + x] = map[(a.y + 1) * mapWidth + x] = Global.floorTile;
				printWall(x, a.y - 1);
				printWall(x, a.y + 2);
			}

			from = Math.min(a.y, b.y);
			to = Math.max(a.y, b.y);
			for (y = from; y < to; y++)
			{
				map[y * mapWidth + b.x] = map[y * mapWidth + b.x + 1] = Global.floorTile;
				printWall(b.x - 1, y);
				printWall(b.x + 2, y);
			}

		}

		private function printWall(x:int, y:int):void
		{
			var location:int = y * mapWidth + x;
			if (map[location] == Global.rockTile)
				map[location] = Global.wallTile;
		}
	}
}