import Vec2D;
import Circle;
import Constants;

class Semiplane {
    public var position:Vec2D;
    public var axis:Vec2D;

    public function new(position:Vec2D, axis:Vec2D) {
        this.position = position;
        this.axis = axis;
    }

    public function intersectsCircle(c:Circle):Bool {
        var v:Vec2D = c.position.sub(position);
        if(v.cross(axis) < 0)
            return true;

        if(c.position.distanceToLine(axis) < c.radius)
            return true;
        
        return false;
    }
}
