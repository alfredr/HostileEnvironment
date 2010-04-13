import flash.display.BitmapData;

class TextureMaterial extends BitmapData {
    public var tilingWidth:Float;
    public var tilingHeight:Float;

    public function new() {
        super(0,0);
    }
}
class BulkheadA extends TextureMaterial {
    public function new() {super();}
}

class BulkheadB extends TextureMaterial {
    public function new() {super();}
}

class ConcreteA extends TextureMaterial {
    public function new() {
        tilingWidth = 1;
        tilingHeight = 1;
        super();
    }
}

class MetalA extends TextureMaterial {
    public function new() {super();}
}

class MetalB extends TextureMaterial {
    public function new() {super();}
}

class RustA extends TextureMaterial {
    public function new() {super();}
}


