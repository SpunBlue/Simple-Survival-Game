package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		#if client
		addChild(new FlxGame(0, 0, PlayState));
		#else
		FlxG.debugger.visible = false;
		trace('Now running in Server Mode');
		#end
	}
}
