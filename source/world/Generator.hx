package world;

import world.Save.ChunkData;
import flixel.addons.util.FlxSimplex;

class Generator
{
    public var biomes:Map<String, Array<Float>> = new Map();

    public function new(?defaultBiomes:Bool = true) {
        if (defaultBiomes) {
            biomes.set('tundra', [-1, -0.5]);
            biomes.set('plains', [-0.5, 0]);
            biomes.set('forest', [0, 0.5]);
            biomes.set('jungle', [0.5, 1]);
            biomes.set('desert', [1, 1.5]);
        }
    }

    public var seed:Int = 0;

    final chunk_size:Int = 8;
    final sea_level:Float = -0.75;

    /**
     * Generate a chunk for the following coordinates
     * @param cX Chunk X Cordinate
     * @param cY Chunk Y Cordinate
     * @return Chunk
     */
    public function generateChunk(cX:Int, cY:Int) 
    {
        var chunk:ChunkData = {
            pos: [cX, cY],
            biome: null,
            tiles: []
        };

        for (x in 0...chunk_size) {
            for (y in 0...chunk_size) {
                // Seems to only be generating grass, look into this later. I really need to learn how perlin noise works.
                var world:Float = FlxSimplex.simplexTiles(x + (cX * chunk_size), y + (cY * chunk_size), 1, 1, seed, 0.25, 2, 4);
                var biome:Float = FlxSimplex.simplexTiles(x + (cX * chunk_size), y + (cY * chunk_size), 1, 1, seed, 0.5, 1.5, 2);
                var foliage:Float = FlxSimplex.simplexTiles(x + (cX * chunk_size), y + (cY * chunk_size), 1, 1, seed, 0.1, 1, 1);

                chunk.biome = pickBiome(biome);

                if (world > (sea_level + 0.05)) {
                    chunk.tiles.push({
                        pos: [x, y],
                        type: 'grass'
                    });

                    // Foliage
                    switch (pickBiome(biome)) {
                        case 'tundra':
                            // TUNDRA
                        case 'plains':
                            // PLAINS
                        case 'forest':
                            // FOREST
                        case 'jungle':
                            // JUNGLE
                        case 'desert':
                            // DESERT
                    }
                }
                else if (world <= (sea_level)){ // Ocean
                    chunk.tiles.push({
                        pos: [x, y],
                        type: 'water'
                    });
                }
                else { // Beach
                    if (pickBiome(biome) == 'tundra') {
                        chunk.tiles.push({
                            pos: [x, y],
                            type: 'ice'
                        });
                    }
                    else {
                        chunk.tiles.push({
                            pos: [x, y],
                            type: 'sand'
                        });
                    }
                }
            }
        }

        return chunk;
    }

    private function pickBiome(temperature:Float) {
        for (biome in biomes.keys()) {
            var range:Array<Float> = biomes.get(biome);
            if (temperature >= range[0] && temperature < range[1]) {
                return biome;
            }
        }

        trace('Biome not found for temperature: $temperature, defaulting to "void".');
        return "void";
    }
}