typedef DungeonCell = {
    height:Int,
    visited:Bool
}

typedef Move = {
    i:Int,
    j:Int
};

class Dungeon {
    public var width:Int;
    public var height:Int;

    var _terrain:Array<DungeonCell>;
    var _moves:Array<Move>;

    public function new(width:Int, height:Int) {
        _terrain = new Array<DungeonCell>();
        _moves = [
            {i:-1, j:0}, {i:1, j:0}, 
            {i:0, j:-1}, {i:0, j:1}
        ]; 

        this.width = 2*width;
        this.height = 2*height;

        for(i in 0...this.width) {
            for (j in 0...this.height) {
                _terrain.push({height: 1, visited: false});
            }
        }

        genMaze(2,2);
    }

    private function shuffleMoves():Array<Move> {
        var moves:Array<Move> = _moves.copy();

        for(n in 0...4) {
            var m:Int = Std.random(4);
            var move:Move = moves[n];
            moves[n] = moves[m];
            moves[m] = move;
        }

        return moves;
    }

    private function genMaze(i:Int, j:Int) {
        var thisCell:DungeonCell = getCell(i,j);
        thisCell.visited = true;
        thisCell.height = 0;

        var moves:Array<Move> = shuffleMoves();
        for(move in moves) {
            var ni:Int = i + 2*move.i;
            var nj:Int = j + 2*move.j;
            
            if(ni < 0 || nj < 0)
                continue;

            if(ni >= width || nj >= height)
                continue;

            if(getCell(ni, nj).visited == false) {
                getCell(i+move.i, j+move.j).height = 0;
                genMaze(ni, nj);
            }
        }
    }

    public function getCell(i:Int, j:Int):DungeonCell {
        return _terrain[j*width + i];
    }
}
