import sandy.materials.BitmapMaterial;

import flash.display.BitmapData;

class TextureImage extends BitmapData {
    public var tilingWidth:Float;
    public var tilingHeight:Float;
    
    public function new(tilingWidth:Float, tilingHeight:Float) {
        this.tilingWidth = tilingWidth;
        this.tilingHeight = tilingHeight;
        super(0,0);
    }
}

class BulkheadA extends TextureImage {
    public static var instance:TextureImage = new BulkheadA(1,1);
}

class BulkheadB extends TextureImage {
    public static var instance:TextureImage = new BulkheadB(1,1);
}

class ConcreteA extends TextureImage {
    public static var instance:TextureImage = new ConcreteA(0.25,0.25);
}

class MetalA extends TextureImage {
    public static var instance:TextureImage = new MetalA(15,15);
}

class MetalB extends TextureImage {
    public static var instance:TextureImage = new MetalB(1,1);
}

class RustA extends TextureImage {
    public static var instance:TextureImage = new RustA(1,1);
}


