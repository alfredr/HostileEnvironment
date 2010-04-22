import Dungeon;
import Textures;
import World;

import sandy.core.Scene3D;
import sandy.core.data.Point3D;
import sandy.core.scenegraph.Group;
import sandy.core.scenegraph.Camera3D;
import sandy.core.scenegraph.TransformGroup;

import sandy.events.Shape3DEvent;

import sandy.materials.Appearance;
import sandy.materials.BitmapMaterial;

import sandy.primitive.Box;
import sandy.primitive.Plane3D;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;

class View extends Sprite {
    var camera:Camera3D;
    var scene:Scene3D;
    var world:World;

    public function new(world:World) {
        super();
        this.world = world;
        initScene();
    }

    function newMaterial(texImg:TextureImage):BitmapMaterial {
        var texMat:BitmapMaterial = new BitmapMaterial(texImg);
        texMat.lightingEnable = true;
        texMat.setTiling(texImg.tilingWidth, texImg.tilingHeight);
        return texMat;
    }

    function initScene():Void {
        var root:Group = createScene();

        camera = new Camera3D(800, 500);
        camera.fov = 25;
        camera.near = 1;
        camera.z = -20;
        camera.y = 10;
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

        var floorMat = newMaterial(MetalA.instance);
        ground.appearance = new Appearance(floorMat);

        g.addChild(ground);
        g.addChild(createDungeonWalls());

        return g;
    }

    function getCellTexture(cell:DungeonCell):TextureImage {
        return switch(cell.cellType) {
            case Wall:
                ConcreteA.instance;
            case Floor:
                ConcreteA.instance;
        }
    }

    function createDungeonWalls():TransformGroup {
        var g:TransformGroup = new TransformGroup();

        for(i in 0...world.dungeon.width) {
            for(j in 0...world.dungeon.height) {
                var cell:DungeonCell = world.dungeon.getCell(i,j);
                if(cell.height < 1)
                    continue;

                var b:Box = new Box("Wall", 1, cell.height, 1);
                
                b.x = i;
                b.z = j;
                
                b.appearance = new Appearance(
                    newMaterial(getCellTexture(cell))
                );

                b.useSingleContainer = false;
                b.enableEvents = true;
                b.addEventListener(MouseEvent.CLICK, clickHandler);

                g.addChild(b);
            }
        }
        g.translate(-world.dungeon.width/2, 0, -world.dungeon.width/2);
        return g;
    }

    public function clickHandler(event:Shape3DEvent) {
        camera.lookAtPoint(event.point);
    }

    public function render():Void {
        scene.render();
    }
}
