#if client
package;

import flixel.FlxState;
import flixel.util.FlxColor;
import world.Creator.WorldCreator;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();

		sys.io.File.saveContent("save.data", WorldCreator.create(0).toString());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
#end