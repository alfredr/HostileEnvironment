import Vec2D;
import Constants;
import Interval;
import Circle;

class Polygon {
    public static function newRectangle(
        position:Vec2D, width:Float, height:Float):Polygon {

        var rect:Polygon = new Polygon();
        var xshift:Vec2D = Vec2D.X_AXIS.scale(width/2);
        var yshift:Vec2D = Vec2D.Y_AXIS.scale(height/2);

        rect.addPoint(position.add(xshift).sub(yshift));
        rect.addPoint(position.add(xshift).add(yshift));
        rect.addPoint(position.sub(xshift).add(yshift));
        rect.addPoint(position.sub(xshift).sub(yshift));

        return rect;
    }

    public var points:Array<Vec2D>;

    public function new() {
        points = new Array<Vec2D>();
    }

    public function addPoint(p:Vec2D):Void {
        points.push(p);
        sortPoints();
    }

    public function containsPoint(p:Vec2D):Bool {
        for(i in 0...points.length) {
            var pA:Vec2D = points[i];
            var pB:Vec2D = points[(i+1) % points.length];
            var edge:Vec2D = pB.sub(pA);
            var v:Vec2D = pA.sub(p);
            if (v.cross(edge) <= 0)
                return false;
        }

        return true;
    }

    private function getCentroid():Vec2D {
        var v:Vec2D = new Vec2D(0,0);

        for(p in points)
            v.add(p);

        return v.scale(1.0/points.length);
    }

    private function sortPoints():Void {
        if(points.length == 0)
            return;

        var refPoint:Vec2D = points[0];

        points.sort(function(v:Vec2D, w:Vec2D) {
            var angV:Float = refPoint.angle(v);
            var angW:Float = refPoint.angle(w);
            if (angV - angW > C.floatEps)
                return 1;
            if (angV - angW < -C.floatEps)
                return -1;
            return 0;
        }); 
    }

    public function project(v:Vec2D):Interval {
        var range:Interval = new Interval();

        for(p in points) {
            var val:Float = p.project(v);
            range.addValue(val);
        }

        return range;
    }

    public function intersectsPolygon(q:Polygon) {
        if(q.points.length < points.length)
            return q.intersectsPolygon(this);

        for(i in 0...points.length) {
            var pA:Vec2D = points[i];
            var pB:Vec2D = points[(i+1) % points.length];
            var edge:Vec2D = pB.sub(pA);
            var axis:Vec2D = edge.perp();

            if(!project(axis).intersects(q.project(axis)))
                return false;
        }

        return true;
    }

    public function intersectsCircle(c:Circle) {
        for(i in 0...points.length) {
            var pA:Vec2D = points[i];
            var pB:Vec2D = points[(i+1) % points.length];
            var edge:Vec2D = pB.sub(pA);
            var axis:Vec2D = edge.perp();

            if(!project(axis).intersects(c.project(axis)))
                return false;
        }

        trace("INT!");
        return true;
    }

    public function toString():String {
        var str:String = "";
        for(p in points) {
            str += p.toString();
        }

        return "Polygon{" + str + "}";
    }
}
