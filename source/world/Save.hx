package world;

/**
 * Only used in-code for the world save data.
 */
typedef WorldInf = {
    var path:String;
    var data:WorldData;
}

typedef WorldData =
{
    var ?description:String;
    var ?creation_date:Int;
    var seed:Int;
}

typedef ChunkData =
{
    var pos:Array<Int>;
    var biome:String;
    var tiles:Array<TileData>;
}

typedef TileData =
{
    var pos:Array<Int>;
    var type:String;
    var ?data:Dynamic;
}

/*typedef EntityData =
{
    var pos:Array<Float>;
    var type:String;
    var data:Dynamic;
}

typedef PlayerData =
{
    var name:String;
    var pos:Array<Float>;
    var data:Dynamic;
}*/