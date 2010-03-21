import Entity;
import Dungeon;
import Polygon;

class World {
    var entities:Array<Entity>;
    var dungeon(default, null):Dungeon;
    var dungeonMap:Array<Polygon>;

    public function new(dungeon:Dungeon) {
        this.dungeon = dungeon;
        for(i in 0...dungeon.width) {
            for(j in 0...dungeon.height) {
                if(dungeon.getCell(i,j).height > 0) {
                    var pos:Vec2D = new Vec2D(i,j);
                    var rect:Polygon = Polygon.newRectangle(
                        pos, 0.5, 0.5
                    );

                    dungeonMap.push(rect);
                }
            }
        }

        entities = new Array<Entity>();
    }

    public function addEntity(entity:Entity):Void {
        entities.push(entity);
    }

    public function canMove(entity:Entity, target:Circle):Bool {
        for(e in entities)
            if(e.geometry.intersectsCircle(target))
                if(e != entity)
                    return false;

        for(rect in dungeonMap)
            if(rect.intersectsCircle(target))
                return false;

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
