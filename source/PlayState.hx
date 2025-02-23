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
	private var game:GameManager;
	private var renderedChunks:Map<String, ChunkData> = new Map();

	private var playerChunkLoader:ChunkLoader = {curChunk: [0, 0], parent: {type: "player", id: 0}};

	override public function create()
	{
		var world = WorldCreator.create(FlxG.random.int(0, FlxMath.MAX_VALUE_INT));
		var worldInf:WorldInf = {
			path: null,
			data: world[0]
		}

		game = new GameManager(worldInf);
		game.addChunkLoader(playerChunkLoader);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!renderedChunks.exists([0, 0].join(','))) {
			trace('Chunk no exist??');
			var chunk = game.retrieveChunk(playerChunkLoader);

			if (chunk != null) {
				for (tile in chunk.tiles) {
					var tileObject:FlxSprite = new FlxSprite(tile.pos[0] * 16, tile.pos[1] * 16);
					switch (tile.type.toLowerCase()) {
						case 'grass':
							tileObject.makeGraphic(16, 16, FlxColor.GREEN);
						case 'sand':
							tileObject.makeGraphic(16, 16, FlxColor.YELLOW);
						case 'water':
							tileObject.makeGraphic(16, 16, FlxColor.BLUE);
						case 'ice':
							tileObject.makeGraphic(16, 16, FlxColor.CYAN);
					}

					add(tileObject);
				}
	
				renderedChunks.set([0, 0].join(','), chunk);
			}
		}
	}
}
#end