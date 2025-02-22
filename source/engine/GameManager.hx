package engine;

import world.Save.ChunkData;
import world.Save.WorldInf;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

/**
 * The GameManager is responsible for managing the game for both the server and client.
 * It will handle events, chunk generation, and entities.
 */

class GameManager
{
    private var tickMgr:FlxTimer;

    private var loadedChunks:Map<Array<Int>, ChunkData> = new Map();
    private var chunkLoaders:Array<ChunkLoader> = [];
    private var deadChunkLoaders:Array<ChunkLoader> = [];

    #if (target.threaded)
    private var chunksInSearch:Array<Array<Int>> = [];
    private var chunkChecking:Bool = false;

    public var waitingOnTickThread:Bool = false;
    private var ticksToCatchUpBy:Int = 0;
    #end
    
    public var properties:GameProperties;
    public var world:WorldInf;

    /**
     * Create a new GameManager
     * @param world Expects the save information (seed, entities, etc).
     */
    public function new(world:WorldInf, ?properties:GameProperties) {
        this.world = world;

        if (properties == null)
            this.properties = { tickRate: 10, maxSize: FlxMath.MAX_VALUE_INT };

        tickMgr = new FlxTimer().start(properties.tickRate / 1000, ( timer ) -> {
            #if (target.threaded)
            if (!waitingOnTickThread) {
                if (ticksToCatchUpBy > 0 && ticksToCatchUpBy < 50) {
                    for (i in 0...ticksToCatchUpBy) {
                        new Thread(()->{
                            waitingOnTickThread = true;
                            update();
                            waitingOnTickThread = false;
                        });
                    }
                }
                else if (ticksToCatchUpBy > 0) {
                    trace('Cannot keep up! We are running behind $ticksToCatchUpBy ticks. Skipping these updates!');
                    ticksToCatchUpBy = 0;
                }

                new Thread(()->{
                    waitingOnTickThread = true;
                    update();
                    waitingOnTickThread = false;
                });
            }
            else {
                ++ticksToCatchUpBy;
            }
            #else
            update();
            #end
        }, 0);
    }

    /**
     * Tick Updates
     */
    private function update() {
        #if (target.threaded)
        if (!chunkChecking) {
            for (loader in deadChunkLoaders) {
                chunkLoaders.remove(loader);
            }
        }
        #else
        for (loader in deadChunkLoaders) {
            chunkLoaders.remove(loader);
        }
        #end

        checkChunks();
    }

    private function checkChunks() {
        // THREAD LATER!!!
        var safeChunks:Array<ChunkData> = [];
        for (chunk in loadedChunks) {
            for (loader in chunkLoaders) {
                if (chunk.pos == loader.curChunk) {
                    safeChunks.push(chunk);
                }
            }

            if (!safeChunks.contains(chunk))
                loadedChunks.remove(chunk.pos);
        }

        for (loader in chunkLoaders) {
            if (loadedChunks.exists(loader.curChunk)) {
                chunkUpdate(loadedChunks.get(loader.curChunk));
            }
            else {
                #if (target.threaded)
                if (!chunksInSearch.contains(loader.curChunk)) {
                    new Thread(()->{
                        chunkChecking = true;
                        loadChunk(loader.curChunk);
                        chunkChecking = false;
                    });
                }
                #else
                loadChunk(loader.curChunk);
                #end
            }
        }
    }

    private function chunkUpdate(chunk:ChunkData) {
        // Update the chunk
    }

    private function loadChunk(chunkPos:Array<Int>) {
        // Load the chunk
    }

    // Messanger - Send packets to the server to be sent to players, or directly to the client if in singleplayer. Or manipulate the GameManager.

    public function addChunkLoader(loader:ChunkLoader) {
        chunkLoaders.push(loader);
    }

    public function removeChunkLoader(loader:ChunkLoader) {
        deadChunkLoaders.push(loader);
    }

    public function removeLoaderOfParent(parent:Dynamic) {
        #if (target.threaded)
        new Thread(()->{
            for (loader in chunkLoaders) {
                if (loader.parent == parent) {
                    deadChunkLoaders.push(loader);
                    break;
                }
            }
        });
        #else
        for (loader in chunkLoaders) {
            if (loader.parent == parent) {
                deadChunkLoaders.push(loader);
                break;
            }
        }
        #end
    }

    public function retrieveChunk(chunkPos:Array<Int>):ChunkData {
        var chunkToReturn:ChunkData = null;

        for (chunk in loadedChunks) {
            if (chunk.pos == chunkPos) {
                chunkToReturn = chunk;
                break;
            }
        }

        return chunkToReturn;
    }
}

typedef GameProperties = {
    var tickRate:Int;
    var maxSize:Int; // In Chunks
}

typedef ChunkLoader = {
    var curChunk:Array<Int>; // X, Y
    var ?parent:Dynamic; // Either null or a player/entity.
}