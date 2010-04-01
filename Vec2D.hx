class Vec2D {
    public static var X_AXIS:Vec2D = new Vec2D(1,0);
    public static var Y_AXIS:Vec2D = new Vec2D(0,1);

    public var x:Float;
    public var y:Float;

    public function new(x:Float, y:Float) {
        this.x = x;
        this.y = y;
    }

    public function add(w:Vec2D):Vec2D {
        return new Vec2D(x+w.x, y+w.y);
    }

    public function sub(w:Vec2D):Vec2D {
        return new Vec2D(x-w.x, y-w.y);
    }

    public function scale(c:Float):Vec2D {
        return new Vec2D(c*x, c*y);
    }

    public function dot(w:Vec2D):Float {
        return x*w.x + y*w.y;
    }

    public function cos(w:Vec2D):Float {
        return this.dot(w)/(this.norm() * w.norm());
    }

    public function angle(w:Vec2D):Float {
        var _ang:Float = Math.acos(this.cos(w));

        if(this.cross(w) >= 0)
            return _ang;

        return 2*Math.PI - _ang;
    }

    public function perp():Vec2D {
        return new Vec2D(y, -x);
    }

    public function cross(w:Vec2D):Float {
        return x*w.y - y*w.x;
    }

    public function norm():Float {
        return Math.sqrt(this.dot(this));
    }

    public function distanceToLine(axis:Vec2D):Float {
        return Math.abs(this.cross(axis)/axis.norm());
    }

    public function normalize():Vec2D {
        return this.scale(1/this.norm());
    }

    public function project(axis:Vec2D):Float {
        return this.dot(axis)/axis.norm();
    }

    public function rotate(angle:Float):Vec2D {
        var cos:Float = Math.cos(angle);
        var sin:Float = Math.sin(angle);
        
        var nx:Float = x*cos - y*sin;
        var ny:Float = x*sin + y*cos;

        return new Vec2D(nx, ny);
    }

    public function toString():String {
        return "Vec2D("+x+","+y+")";
    }
}
