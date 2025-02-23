package world;

import world.Save.ChunkData;
import noisehx.Perlin;

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

    public static final chunk_size:Int = 8;
    public static final tile_size:Int = 16;

    final sea_level:Float = -0.5;

    /**
     * Generate a chunk for the following coordinates
     * @param cX Chunk X Cordinate
     * @param cY Chunk Y Cordinate
     * @return Chunk
     */
    public function generateChunk(cX:Int, cY:Int) 
    {
        var noise = new Perlin(seed);

        var chunk:ChunkData = {
            pos: [cX, cY],
            biome: null,
            tiles: []
        };

        for (x in 0...chunk_size) {
            for (y in 0...chunk_size) {
                var world:Float = Math.max(-1, Math.min(1, noise.noise2d((x + (cX * chunk_size)) / tile_size, (y + (cY * chunk_size)) / tile_size, 2, 2)));
                var biome:Float = Math.max(-1, Math.min(1, noise.noise2d((x + (cX * chunk_size)) / (chunk_size * tile_size), (y + (cY * chunk_size)) / (chunk_size * tile_size), 4, 4)));           

                if (world > (sea_level + 0.5)) {
                    var sectionBiome = pickBiome(biome);

                    // Ground
                    switch (sectionBiome) {
                        default:
                            chunk.tiles.push({
                                pos: [x, y],
                                type: 'grass'
                            });
                        case 'tundra':
                            chunk.tiles.push({
                                pos: [x, y],
                                type: 'snow'
                            });
                        case 'desert':
                            chunk.tiles.push({
                                pos: [x, y],
                                type: 'sand'
                            });
                    }

                    // Foliage
                    switch (sectionBiome) {
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

                    chunk.biome = sectionBiome; // Last Instance chooses the entire chunk's biome.
                }
                else if (world <= sea_level){ // Ocean
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