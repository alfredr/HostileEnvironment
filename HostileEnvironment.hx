import Dungeon;
import View;
import World;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

class HostileEnvironment extends Sprite {
    var view:View;
    var world:World;

    public function new() {
        super();

        world = new World(new Dungeon(10,10));
        view = new View(world);
        addChild(view);

        addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        Lib.current.stage.addChild(this);
    }

    public function enterFrameHandler(event:Event):Void {
        world.tick(0.1);
        view.render();
    }

    static function main() {
        new HostileEnvironment();
    }
}
