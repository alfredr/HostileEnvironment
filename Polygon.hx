import Vec2D;
import Constants;
import Interval;
import Circle;
import Utility;

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

    public function convexHull():Polygon {
        //Graham Scan
        var convexPoly:Polygon = new Polygon();
        
        if (points.length <= 3) {
            convexPoly.points = points;
            return convexPoly;
        }

        var tmpPoints:Array<Vec2D> = points.copy();
        tmpPoints.sort(
            function(p:Vec2D, q:Vec2D):Int {
                if (Utility.greaterFloat(p.y, q.y))
                    return 1;
                if (Utility.lesserFloat(p.y, q.y))
                    return -1;
                if (Utility.greaterFloat(p.x, q.x))
                    return 1;
                if (Utility.lesserFloat(p.x, q.x))
                    return -1;

                return 0;
            }
        );

        var refPoint:Vec2D = tmpPoints[0];
        tmpPoints.sort(
            function(p:Vec2D, q:Vec2D):Int {
                var angP:Float = refPoint.angle(p);
                var angQ:Float = refPoint.angle(q);

                if (Utility.greaterFloat(angP, angQ))
                    return 1;
                if (Utility.lesserFloat(angP, angQ))
                    return -1;

                var magP:Float = p.sub(refPoint).norm();
                var magQ:Float = q.sub(refPoint).norm();

                if (Utility.greaterFloat(magP, magQ))
                    return 1;
                if (Utility.lesserFloat(magP, magQ))
                    return -1;

                return 0;
            }
        );

        tmpPoints.push(refPoint);
        tmpPoints.shift();
        var convexPoints:Array<Vec2D> = tmpPoints.splice(0, 2);
        for (ptB in tmpPoints) {
            var len:Int = convexPoints.length;
            var ptA:Vec2D = convexPoints[len-1];
            var o:Vec2D = convexPoints[len-2];

            var v:Vec2D = ptA.sub(o);
            var w:Vec2D = ptB.sub(o);

            if (v.cross(w) < C.floatEps) 
                convexPoints.pop();
            
            convexPoints.push(ptB);
        }

        convexPoly.points = convexPoints;
        return convexPoly;
    }

    private function sortPoints():Void {
        if(points.length == 0)
            return;

        var refPoint:Vec2D = points[0];

        points.sort(function(v:Vec2D, w:Vec2D) {
            var angV:Float = refPoint.angle(v);
            var angW:Float = refPoint.angle(w);
            if (Utility.greaterFloat(angV, angW))
                return 1;
            if (Utility.lesserFloat(angV, angW))
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
