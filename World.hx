import Entity;
import Dungeon;
import Polygon;
import Semiplane;

class World {
    public var entities:Array<Entity>;
    var dungeon(default, null):Dungeon;
    var dungeonMap:Array<Polygon>;
    var bounds:Array<Semiplane>;

    public function new(dungeon:Dungeon) {
        this.dungeon = dungeon;
        var dw:Int = dungeon.width;
        var dh:Int = dungeon.height;

        entities = new Array<Entity>();

        bounds = new Array<Semiplane>();
        bounds.push(new Semiplane(new Vec2D(0,0), new Vec2D(-1,0)));
        bounds.push(new Semiplane(new Vec2D(0,0), new Vec2D(0,1)));
        bounds.push(new Semiplane(new Vec2D(dw, dh), new Vec2D(1,0)));
        bounds.push(new Semiplane(new Vec2D(dw, dh), new Vec2D(0,-1)));
        
        dungeonMap = new Array<Polygon>();
        for(i in 0...dw) {
            for(j in 0...dh) {
                if(dungeon.getCell(i,j).height > 0) {
                    var pos:Vec2D = new Vec2D(0.5+i,0.5+j);
                    var rect:Polygon = Polygon.newRectangle(
                        pos, 1, 1
                    );
                    dungeonMap.push(rect);
                }
            }
        }
   }

    public function addEntity(entity:Entity):Void {
        entities.push(entity);
    }

    public function canMove(entity:Entity, target:Circle):Bool {
        for(e in entities)
            if(e.geometry.intersectsCircle(target))
                if(e != entity ) {
                    return false;
                }

        for(s in bounds) {
            if(s.intersectsCircle(target)) {
                return false;
            }
        }

        for(rect in dungeonMap) {   
            if(rect.intersectsCircle(target)) {
                return false;
            }
        }

        return true;
    }

    public function moveEntity(entity:Entity, target:Circle):Bool {
        if(canMove(entity, target)) {
            entity.geometry = target;
            return true;
        }

        return false;
    }

    public function getEntitiesNear(entity:Entity, radius:Float):List<Null<Entity>> {
        return Lambda.filter(entities, function(e:Entity) {  
            return (entity.distanceFrom(e) <= radius) 
                    && (entity != e);
        });
    }

    public function tick(dt:Float):Void {
        for (entity in entities) {
            entity.tick(this, dt);
        }
    }
}
