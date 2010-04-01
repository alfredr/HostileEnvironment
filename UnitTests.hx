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

    public static function pointInPTest() {
        var p:Polygon = new Polygon();
        var r:Float = 3; 
        for(i in 0...6) {
            var angle:Float = i*2*Math.PI/6;
            var x:Float = r*Math.cos(angle);
            var y:Float = r*Math.sin(angle);
            p.addPoint(new Vec2D(x,y));
        }

        var rowCount:Int = 10;
        var colCount:Int = 10;

        var rowStep:Float = 3*r/rowCount;
        var colStep:Float = 3*r/colCount;

        for(i in 0...rowCount) {
            var row:String = "";
            var rPos:Float = -1.5*r + i*rowStep;
            for(j in 0...colCount) {
                var cPos:Float = 1.5*r - j*colStep;
                if(p.pointInPolygon(new Vec2D(cPos, rPos)))
                    row += "X";
                else
                    row += "O";
            }
            trace(row);
        }
    }

    public static function runTests() {
        circleTests();
        polygonTests();
        pointInPTest();
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


