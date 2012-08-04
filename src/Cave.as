package

{

	import org.flixel.*;

	[SWF(width="480", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	public class Cave extends FlxGame

	{
		public function Cave()
		{
			super(240,240,MenuState,2, 60, 60);
			forceDebugger = true;
		}

	}

}

