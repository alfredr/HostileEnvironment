import sandy.core.data.Matrix4;
import sandy.core.data.Vertex;
import sandy.core.data.Point3D;

import sandy.core.Scene3D;
import sandy.core.scenegraph.Geometry3D;
import sandy.core.scenegraph.Group;
import sandy.core.scenegraph.Shape3D;
import sandy.core.scenegraph.SpringCamera3D;
import sandy.core.scenegraph.TransformGroup;

import sandy.materials.Appearance;
import sandy.materials.Material;
import sandy.materials.BitmapMaterial;
import sandy.materials.attributes.LightAttributes;
import sandy.materials.attributes.LineAttributes;
import sandy.materials.attributes.MaterialAttributes;

import sandy.parser.Parser;
import sandy.parser.ParserEvent;
import sandy.parser.ColladaParser;

import sandy.primitive.Box;
import sandy.primitive.Plane3D;
import sandy.primitive.Sphere;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.Lib;

import haxe.Log;

import Circle;
import Dungeon;
import Enemy;
import Polygon;
import RobotMesh;
import Vec2D;
import World;

typedef WallView = {
    box:Box,
    isClose:Bool
};

typedef ZPolygon = {
    z:Float,
    polygon:Polygon,
    box:Box
};

class Game extends Sprite {

    var scene:Scene3D;
    var camera:SpringCamera3D;
    var robot:RobotMesh;
    var dungeon:Dungeon;
    var walls:Array<WallView>;
    var tg:TransformGroup;
    var world:World;
    var enemy:Enemy;
    var enemySphere:Sphere;
    var noOcclude:Array<Geometry3D>;
    var wallBmp:Bitmap;

    var cellWidth:Int;

    public function new() {
        super();

        wallBmp = new Bitmap(new MetalA());
        cellWidth = 1;
        dungeon = new Dungeon(5,5);
        world = new World(dungeon);
        
        var enemyGeom:Circle = new Circle(new Vec2D(1.5,1.5), 0.05);
        enemy = new Enemy(enemyGeom, new Vec2D(1,0));
        world.addEntity(enemy);

        noOcclude = new Array<Geometry3D>();

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

        camera = new SpringCamera3D(800, 600);
        //-2.5, 3.5, -2.5
        camera.positionOffset.z = -5;
        camera.positionOffset.x = -5;
        camera.positionOffset.y = 7;
        camera.lookOffset.y = -7;
        camera.lookOffset.x = 5;
        camera.lookOffset.z = 5;
        camera.fov = 25;
        camera.near = 1;
        camera.mass = 40;
        camera.damping = 3;
        camera.z = 0;
        camera.target = enemySphere;
        camera.enableBackFaceCulling = true;

        scene = new Scene3D("scene", this, camera, root);
        
    }

    function createScene():Group {
        var g:Group = new Group();

        tg = new TransformGroup();
        walls = new Array<WallView>();

        var material:Material = new BitmapMaterial( wallBmp.bitmapData );
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
                walls.push({box:b, isClose:false});
            }
        }

        robot = new RobotMesh();
        robot.swapCulling();
        robot.x = 0;
        robot.y = 0;
        robot.z = 0;
        robot.appearance = app;
        //tg.addChild(robot);

        enemySphere = new Sphere("", enemy.geometry.radius, 8, 8);
        enemySphere.x = 2;
        enemySphere.z = 2;
        enemySphere.y = enemy.geometry.radius;
        enemySphere.appearance = app;
        noOcclude.push(enemySphere.geometry);

        tg.addChild(enemySphere);

        g.addChild(tg);
        return g;
    }

    function enterFrameHandler(event:Event):Void {
        enemy.velocity = 0.75;
        world.tick(0.1);
        enemySphere.x = enemy.geometry.position.x - 0.5;
        enemySphere.z = enemy.geometry.position.y - 0.5;
        scene.render();
        adjustVisibility();
    }

    function adjustVisibility():Void {
        var zpolys:Array<ZPolygon> = new Array<ZPolygon>();

        for (wall in walls) {
            var bestZ:Float = 0;
            var nVerts:Int = 0;
            var polygon:Polygon = new Polygon();

            for (vert in wall.box.geometry.aVertex) {
                if(! vert.transformed)
                    continue;

                nVerts++;
                var p:Point3D = vert.getScreenPoint();
                polygon.addPoint(new Vec2D(p.x, p.y));
                bestZ += p.z;
            }

            bestZ = bestZ / nVerts;
            
            zpolys.push({z:bestZ, polygon:polygon.convexHull(), box:wall.box});
        }

        for (geom in noOcclude) {
            var geomZ:Float = Math.POSITIVE_INFINITY;
            var geomPoly:Polygon = new Polygon();
            for(vert in geom.aVertex) {
                if(!vert.transformed)
                    continue;

                var p:Point3D = vert.getScreenPoint();
                geomPoly.addPoint(new Vec2D(p.x, p.y));
                geomZ = Math.min(geomZ, vert.getScreenPoint().z);
            }

            geomPoly = geomPoly.convexHull();

            for(zpoly in zpolys) {
                var alpha:Float = if (zpoly.z <= geomZ &&zpoly.polygon.intersectsPolygon(geomPoly)) 0 else 1.0;
                var material:BitmapMaterial = new BitmapMaterial( wallBmp.bitmapData );
                material.alpha = alpha;
                material.lightingEnable = true;
                var app:Appearance = new Appearance( material);

                zpoly.box.appearance = app;
            }
        }
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
#if (flash9 || flash10)
        haxe.Log.trace = function(v,?pos) { untyped __global__["trace"](pos.className+"#"+pos.methodName+"("+pos.lineNumber+"):",v); }
#elseif flash
        haxe.Log.trace = function(v,?pos) { flash.Lib.trace(pos.className+"#"+pos.methodName+"("+pos.lineNumber+"): "+v); }
#end
        new Game();
    }
}
