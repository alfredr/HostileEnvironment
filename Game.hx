import sandy.core.Scene3D;
import sandy.core.scenegraph.Camera3D;
import sandy.core.scenegraph.Group;
import sandy.core.scenegraph.TransformGroup;

import sandy.materials.Appearance;
import sandy.materials.Material;
import sandy.materials.ColorMaterial;
import sandy.materials.attributes.LightAttributes;
import sandy.materials.attributes.LineAttributes;
import sandy.materials.attributes.MaterialAttributes;

import sandy.parser.Parser;
import sandy.parser.ParserEvent;
import sandy.parser.ColladaParser;

import sandy.primitive.Box;
import sandy.primitive.Plane3D;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.Lib;

import Dungeon;
import RobotMesh;
import World;

class Game extends Sprite {

    var scene:Scene3D;
    var camera:Camera3D;
    var robot:RobotMesh;
    var dungeon:Dungeon;
    var tg:TransformGroup;

    var cellWidth:Int;

    public function new() {
        super();
        cellWidth = 1;
        dungeon = new Dungeon(5,5);

        initScene();

        addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        Lib.current.stage.addEventListener(
            KeyboardEvent.KEY_DOWN, 
            keyPressed
        );

        Lib.current.stage.addChild(this);
    }

    function initScene():Void {       
        var root:Group = createScene();

        camera = new Camera3D(550, 400);
        camera.z = -10 ;
        camera.y = 15;
        camera.x = -10 ;
        camera.fov = 30;
        camera.near = 5;
        camera.lookAt(0,0,0);

        scene = new Scene3D("scene", this, camera, root);
        
    }

    function createScene():Group {
        var g:Group = new Group();
        tg = new TransformGroup();
        var materialAttr:MaterialAttributes = new MaterialAttributes([
            new LineAttributes( 0.5, 0x2111BB, 0.4 ),
            new LightAttributes( true, 0.1 )
        ]);

        var material:Material = new ColorMaterial( 0xFFCC33, 1, materialAttr );
        material.lightingEnable = true;
        var app:Appearance = new Appearance( material );
     
        var groundWidth:Float = cellWidth * dungeon.width;
        var groundHeight:Float = cellWidth * dungeon.height;

        var ground:Plane3D = new Plane3D(
            groundWidth, groundHeight,
            5, 5, 
            Plane3D.ZX_ALIGNED
        );

        ground.appearance = app;
        ground.enableForcedDepth = true;
        ground.forcedDepth = 99999999;

        var cellCorrection:Float = cellWidth / 2;
        ground.x = groundWidth / 2 - cellCorrection;
        ground.z = groundHeight / 2 - cellCorrection;
        ground.y = -cellCorrection;

        tg.addChild(ground);
        
        for(i in 0...dungeon.width) {
            for(j in 0...dungeon.height) {
                var cell:DungeonCell = dungeon.getCell(i,j);
                if(cell.height < 1)
                    continue;

                var b:Box = new Box("Box", cellWidth, 
                                cellWidth*cell.height, cellWidth);
                b.x = cellWidth * i;
                b.z = cellWidth * j;
                b.appearance = app;
                b.useSingleContainer = false;
                tg.addChild(b);
            }
        }

        robot = new RobotMesh();
        robot.swapCulling();
        robot.x = 0;
        robot.y = 5;
        robot.z = 0;
        robot.appearance = app;
        tg.addChild(robot);
      
        g.addChild(tg);
        return g;
    }

    function enterFrameHandler(event:Event):Void {
        scene.render();
    }

    function keyPressed(event:KeyboardEvent):Void {
        switch(event.keyCode) {
            case Keyboard.UP: 
                camera.tilt--;
            case Keyboard.DOWN:
                camera.tilt++;
            case Keyboard.LEFT:
                camera.pan--;
            case Keyboard.RIGHT:
                camera.pan++;
            case 87:
                robot.tilt--;
            case 65:
                robot.pan--;
            case 83:
                robot.tilt++;
            case 68:
                robot.pan++;

            case 84:
                robot.tilt-=90;
                robot.pan+=90;
                robot.tilt+=90;
                robot.pan-=90;
        }
    }

    static function main() {
        new Game();
    }
}
