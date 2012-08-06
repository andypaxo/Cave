package
{

	import org.flixel.*;

	public class MenuState extends FlxState
	{
		
		private var playButton:FlxButton;
		private var devButton:FlxButton;
		private var Title:FlxText;
		
		override public function create():void
		{
			FlxG.bgColor = 0xff000000;
			
			Title = new FlxText(0, FlxG.height / 3, FlxG.width, "Cavern")
			Title.alignment = "center";
			add(Title);
			
			playButton = new FlxButton(FlxG.width/2-40,FlxG.height / 3 + 100, "Descend", onPlay);
			playButton.color = 0xffD4D943;
			playButton.label.color = 0xffD8EBA2;
			add(playButton);
			
			FlxG.mouse.show();
			if (FlxG.music)
				FlxG.music.stop();
			Global.reset();
		}
		
		override public function update():void
		{
			super.update();	
		}
		
		protected function onPlay():void
		{
			playButton.exists = false;
			FlxG.switchState(new PlayState());
		}
		
	}
}

