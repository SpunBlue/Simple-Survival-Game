package world;

import flixel.graphics.atlas.AseAtlas;
import world.Save.ChunkData;
import engine.Thread;
import world.Save.WorldData;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;

class WorldCreator 
{
    public static function create(seed:Int):Array<Dynamic> {
        var generator = new Generator();
        generator.seed = seed;

        var save:WorldData = {
            seed: seed
        };

        var chunks:Array<ChunkData> = [];

        var generateChunks = ()-> {
            for (x in 0...3) {
                var x = x - 1;

                for (y in 0...3) {
                    var y = y - 1;

                    chunks.push(generator.generateChunk(x, y));
                }
            }
        };

        generateChunks();

        return [save, chunks];
    }
}