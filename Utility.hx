import Constants;

class Utility {
    public static function equalFloat(a:Float, b:Float):Bool {
        return Math.abs(a-b) > C.floatEps;
    }

    public static function greaterFloat(a:Float, b:Float):Bool {
        return (a - b) > C.floatEps;
    }

    public static function lesserFloat(a:Float, b:Float):Bool {
        return greaterFloat(b, a);
    }
}
