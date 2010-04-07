import Circle;

class UnitTests {
    public static function circleTests() {
        var c:Circle = new Circle(new Vec2D(0, 1), 0.5);
        var range:Interval = c.project((new Vec2D(-1, 1)).normalize());
        trace ("range: " + range.toString());
    }

    public static function polygonTests() {
        var p:Polygon = new Polygon();
        p.addPoint(new Vec2D(1,1));
        p.addPoint(new Vec2D(2,3));
        p.addPoint(new Vec2D(4,5));
        trace (p.project(new Vec2D(1,1)));
    }

    public static function displayPolygon(p:Polygon, 
        width:Float, height:Float, rowCount:Int, colCount:Int) {

        var rowStep:Float = height/rowCount;
        var colStep:Float = width/colCount;

        for(i in 0...rowCount) {
            var row:String = "";
            var rPos:Float = height/2 - i*rowStep;
            for(j in 0...colCount) {
                var cPos:Float = -width/2 + j*colStep;
                if(p.containsPoint(new Vec2D(cPos, rPos)))
                    row += "#";
                else
                    row += " ";
            }
            trace(row);
        }

    }

    public static function pointInPTest() {
        var p:Polygon = new Polygon();
        var r:Float = 3.0; 
        for(i in 0...6) {
            var angle:Float = i*2*Math.PI/6;
            var x:Float = r*Math.cos(angle);
            var y:Float = r*Math.sin(angle);
            p.addPoint(new Vec2D(x,y));
        }

        displayPolygon(p, 3*r, 3*r, 50, 50);

    }

    public static function convexHullTest() {
        var p:Polygon = new Polygon();
        var r:Float = 3.0; 
        for(i in 0...6) {
            var angle:Float = i*2*Math.PI/6;
            var x:Float = r*Math.cos(angle);
            var y:Float = r*Math.sin(angle);
        
            var correctPt:Vec2D = new Vec2D(x,y);
            var wrongPt:Vec2D = new Vec2D(.8*x, .7*y);
            p.addPoint(correctPt);
            p.addPoint(wrongPt);
        }

        for(point in p.points)
            trace(point.toString());

        var convexPoly:Polygon = p.convexHull();
        for(point in convexPoly.points)
            trace(point.toString());

        displayPolygon(convexPoly, 3*r, 3*r, 50, 50);
   
    }

    public static function runTests() {
        circleTests();
        polygonTests();
        pointInPTest();
        convexHullTest();
    }

    public static function main():Void {
#if (flash9 || flash10)
        haxe.Log.trace = function(v,?pos) { untyped __global__["trace"](pos.className+"#"+pos.methodName+"("+pos.lineNumber+"):",v); }
#elseif flash
        haxe.Log.trace = function(v,?pos) { flash.Lib.trace(pos.className+"#"+pos.methodName+"("+pos.lineNumber+"): "+v); }
#end
        runTests();
    }
}


