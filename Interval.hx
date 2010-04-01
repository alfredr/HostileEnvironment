
class Interval {
    public var low:Float;
    public var high:Float;

    public function new() {
        high = Math.NEGATIVE_INFINITY;
        low = Math.POSITIVE_INFINITY;
    }

    public function addValue(value:Float):Void {
        if(value > high)
            high = value;
        if(value < low)
            low = value;
    }

    public function toString():String {
        return "["+low+","+high+"]";
    }

    public function intersects(range:Interval):Bool {
        if(low <= range.low && range.low <= high)
            return true;

        if(low <= range.high && range.high <= high)
            return true;

        if(range.low <= low && low <= range.high)
            return true;

        if(range.low <= high && high <= range.high)
            return true;

        return false;
    }
}
