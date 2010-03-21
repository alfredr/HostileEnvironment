import Circle;
import Vec2D;
import World;

class Entity {
    public var typeLabel:String;
    public var orientation:Vec2D;
    public var geometry:Circle;
    public var velocity:Float;

    public function new(geometry:Circle, orientation:Vec2D) {
        this.typeLabel = "Entity";
        this.geometry = geometry;
        this.orientation = orientation.normalize();
        this.velocity = 0;
    }

    public function tick(world:World, dt:Float):Void {

    }

    public function distanceFrom(entity:Entity):Float {
        var position:Vec2D = geometry.position;
        return position.sub(entity.geometry.position).norm();
    }
}
