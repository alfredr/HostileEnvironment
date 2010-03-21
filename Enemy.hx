import Entity;
import Dungeon;
import Vec2D;

class Enemy extends Entity {
    private static moveRetryCount:Float = 5;

    public function new(geometry:Circle, orientation:Vec2D) {
        super(geometry, orientation);
        this.typeLabel = "Enemy";
    }

    public override function tick(world:World, dt:Float):Void {
        for(i in 0...moveRetryCount) {
            var newPos:Vec2D = geometry.position + orientation*velocity*dt;
            var target:Circle = new Circle(newPos, geometry.radius);
            
            if(world.moveEntity(this, target))
                break;

            var angle:Float = (1.0*Std.random(628))/100;
            orientation = orientation.rotate(angle);
        }
    }
}
