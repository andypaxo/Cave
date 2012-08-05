package  
{
	import org.flixel.*;
	
	public interface PlayStage 
	{
		function digAt(point:FlxPoint):void;
		function rockAt(point:FlxPoint):uint;
	}
	
}