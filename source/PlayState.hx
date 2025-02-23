#if client
package;
import flixel.FlxState;
import flixel.util.FlxColor;
import world.Creator.WorldCreator;
import world.Generator;
import engine.GameManager;
import world.Save.WorldInf;
import world.Save.ChunkData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	override public function create()
	{
		FlxG.camera.zoom = 0.8;

		super.create();

		var generator = new Generator();
		generator.seed = 69420;
		trace('Seed: ${generator.seed}');

		for (x in 0...8) {
			for (y in 0...8) {
				var chunk = generator.generateChunk(x, y);

				for (tile in chunk.tiles) {
					var tileObject:FlxSprite = new FlxSprite((tile.pos[0] + (x * Generator.chunk_size)) * Generator.tile_size, (tile.pos[1]+ (y * Generator.chunk_size)) * Generator.tile_size);
					switch (tile.type.toLowerCase()) {
						case 'grass':
							tileObject.makeGraphic(16, 16, FlxColor.GREEN);
						case 'sand':
							tileObject.makeGraphic(16, 16, FlxColor.YELLOW);
						case 'water':
							tileObject.makeGraphic(16, 16, FlxColor.BLUE);
						case 'ice':
							tileObject.makeGraphic(16, 16, FlxColor.CYAN);
						case 'snow':
							tileObject.makeGraphic(16, 16, FlxColor.WHITE);
					}
		
					add(tileObject);
				}
			}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.pressed.W)
			FlxG.camera.scroll.y -= 5;
		else if (FlxG.keys.pressed.S)
			FlxG.camera.scroll.y += 5;

		if (FlxG.keys.pressed.A)
			FlxG.camera.scroll.x -= 5;
		else if (FlxG.keys.pressed.D)
			FlxG.camera.scroll.x += 5;
	}
}
#end