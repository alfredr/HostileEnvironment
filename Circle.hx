import Vec2D;
import Polygon;
import Constants;
import Semiplane;

class Circle {
    public var position:Vec2D;
    public var radius:Float;

    public function new(position:Vec2D, radius:Float) {
        this.position = position;
        this.radius = radius;
    }

    public function project(axis:Vec2D) {
        var range:Interval = new Interval();
        var perp:Vec2D = axis.perp();
        var shift:Float = perp.cross(position)/perp.norm();
        
        range.low = shift - radius;
        range.high = shift + radius;

        return range;
    }

    public function intersectsPolygon(p:Polygon):Bool {
        return p.intersectsCircle(this);
    }

    public function intersectsCircle(c:Circle):Bool {
        var dist:Float = position.sub(c.position).norm();
        
        if(radius + c.radius - dist > C.floatEps)
            return true;

        return false;
    }

    public function intersectsSemiplane(s:Semiplane):Bool {
        return s.intersectsCircle(this);
    }

    public function toString():String {
        return "Circle("+position.toString()+","+radius+")";
    }


}
