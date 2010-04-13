import Dungeon;
import World;

import sandy.core.Scene3D;
import sandy.core.data.Point3D;
import sandy.core.scenegraph.Group;
import sandy.core.scenegraph.Camera3D;
import sandy.core.scenegraph.TransformGroup;

import sandy.materials.Appearance;
import sandy.materials.ColorMaterial;
import sandy.materials.Material;
import sandy.materials.attributes.LightAttributes;
import sandy.materials.attributes.LineAttributes;
import sandy.materials.attributes.MaterialAttributes;

import sandy.primitive.Box;
import sandy.primitive.Plane3D;

import flash.display.Sprite;

class View extends Sprite {
    var camera:Camera3D;
    var scene:Scene3D;
    var world:World;

    public function new(world:World) {
        super();
        this.world = world;
        initScene();
    }

    function initScene():Void {
        var root:Group = createScene();

        camera = new Camera3D(550, 400);
        camera.fov = 25;
        camera.near = 1;
        camera.z = -60;
        camera.y = 60;
        camera.lookAt(0,0,0);

        scene = new Scene3D("scene", this, camera, root);
    }

    function createScene():Group {
        var g:Group = new Group();
       
        var ground:Plane3D = new Plane3D(
            world.dungeon.width, world.dungeon.height, 
            1, 1, Plane3D.ZX_ALIGNED
        );
        ground.x = -0.5;
        ground.z = -0.5;
        ground.enableForcedDepth = true;
        ground.forcedDepth = 1e9;
        g.addChild(ground);

        g.addChild(createDungeonWalls());

        return g;
    }

    function createDungeonWalls():TransformGroup {
        var g:TransformGroup = new TransformGroup();
        var materialAttr:MaterialAttributes = new MaterialAttributes([ 
            new LineAttributes( 0.5, 0x2111BB, 0.4 ),
            new LightAttributes( true, 0.1)
        ]);

        var material:Material = new ColorMaterial( 0xFFCC33, 1, materialAttr );
        material.lightingEnable = true;
        var app:Appearance = new Appearance( material );

        for(i in 0...world.dungeon.width) {
            for(j in 0...world.dungeon.height) {
                var cell:DungeonCell = world.dungeon.getCell(i,j);
                if(cell.height < 1)
                    continue;

                var b:Box = new Box("Wall", 1, cell.height, 1);
                b.x = i;
                b.z = j;
                b.appearance = app;
                b.useSingleContainer = false;
                g.addChild(b);
            }
        }
        g.translate(-world.dungeon.width/2, 0, -world.dungeon.width/2);
        return g;
    }

    public function render():Void {
        scene.render();
    }
}
