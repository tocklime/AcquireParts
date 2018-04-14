piece_w = 20; //width of piece
tol = 1; //difference in width piece and slot.
letter_depth = 0.4;
text_fudge = -0.3;
board_h = 8;
piece_inset = 5;
piece_sep = 5; //width of separating pieces.
magnet = [5.15,5.15,1.5];
mouse_ears = 10;


function total(count) = count * (piece_w+tol+piece_sep) + piece_sep;


module base(x,y){
    translate([0,-total(y),0])
    cube([total(x),total(y),board_h]);
}
module pieceHoles(rows,cols){
    
            for(ci=[0:len(cols)-1])
            for(ri = [0:len(rows)-1])
            {
                translate([piece_sep+ci*(piece_w+tol+piece_sep),-(piece_sep+ri*(piece_w+tol+piece_sep)),board_h - piece_inset])
                union(){
                translate([0,-(piece_w+tol),0])
                cube([piece_w+tol,piece_w+tol,piece_inset]);
                translate([(piece_w+tol)/2,-(piece_w+tol)/2,-letter_depth])
                t(str(cols[ci],rows[ri]),7,":style=Bold");
                }
            }
        }
module magnetHoles(side,x,y){
    total_w = total(x);
    total_d = total(y);
    
    inset = magnet[2]/2 + piece_sep/2;
    if(side == 1){
        translate([total_w/3,-inset,board_h/2])
        rotate([90,0,0]) cube(magnet,center=true);
        translate([2*total_w/3,-inset,board_h/2])
        rotate([90,0,0]) cube(magnet,center=true);
        translate([0,-piece_sep/2,0])
        cube([total_w,piece_sep/2,board_h]);
    }else if(side == 2){
        translate([total_w-inset,-total_d/3,board_h/2])
        rotate([90,0,90]) cube(magnet,center=true);
        translate([total_w-inset,-2*total_d/3,board_h/2])
        rotate([90,0,90]) cube(magnet,center=true);
        translate([total_w-piece_sep/2,-total_d,0])
        cube([piece_sep/2,total_d,board_h]);
    }else if(side == 3){
        translate([total_w/3,inset-total_d,board_h/2])
        rotate([90,0,0]) cube(magnet,center=true);
        translate([2*total_w/3,inset-total_d,board_h/2])
        rotate([90,0,0]) cube(magnet,center=true);
        translate([0,-total_d,0])
        cube([total_w,piece_sep/2,board_h]);
    }else if(side == 4){
        translate([inset,-total_d/3,board_h/2])
        rotate([90,0,90]) cube(magnet,center=true);
        translate([inset,-2*total_d/3,board_h/2])
        rotate([90,0,90]) cube(magnet,center=true);
        translate([0,-total_d,0])
        cube([piece_sep/2,total_d,board_h]);
        
    }
}
module withInsets(rows,cols,magSide1,magSide2){
    y = len(rows);
    x = len(cols);
    off1 = magSide1 == 1 || magSide2 == 1;
    off2 = magSide1 == 2 || magSide2 == 2;
    off3 = magSide1 == 3 || magSide2 == 3;
    off4 = magSide1 == 4 || magSide2 == 4;
    d = piece_sep/2;
    union(){
        difference(){
            union(){
                base(x,y);


            }
            magnetHoles(magSide1,x,y);
            
            magnetHoles(magSide2,x,y);
            
            pieceHoles(rows,cols);
        }
        
        translate([off4 ? d : 0,off1 ? -d : 0,0])
        cylinder(0.2,mouse_ears,mouse_ears);
        translate([total(x)+(off2 ? -d : 0),off1 ? -d : 0,0])
        cylinder(0.2,mouse_ears,mouse_ears);
        translate([off4 ? d : 0,(off3 ? d : 0) -total(y),0])
        cylinder(0.2,mouse_ears,mouse_ears);
        translate([(off2 ? -d : 0)+total(x),(off3 ? d : 0)-total(y),0])
        cylinder(0.2,mouse_ears,mouse_ears);
    }
}

module anticirclecorner(r){
    difference(){
        cube([r,r,r]);
        sphere(r);
    }
}
module anticylinderedge(r,l){
    translate([0,0,-l])
    difference(){
        cube([r+0.01,r+0.01,l+0.01]);
        cylinder(h=l,r=r);
    }
}
module flat_bottomed_rounded_cube(v,r, roundtop=true){
    difference(){
        cube(v); //base.
        if(roundtop){
        translate([v[0]-r,0,v[2]-r])
        rotate([90,0,0])
        anticylinderedge(r=r,l=v[1],$fn=20);
        translate([0,v[1]-r,v[2]-r])
        rotate([0,-90,0])
        anticylinderedge(r=r,l=v[0],$fn=20);
        translate([r,v[1],v[2]-r])
        rotate([-90,180,0])
        anticylinderedge(r=r,l=v[1],$fn=20);
        translate([v[0],r,v[2]-r])
        rotate([90,-90,90])
        anticylinderedge(r=r,l=v[0],$fn=20);
        }
        
        translate([v[0]-r,v[1]-r,v[2]]) rotate([0,0,0])
        anticylinderedge(r=r,l=v[2],$fn=20);
        translate([r,v[1]-r,v[2]]) rotate([0,0,90])
        anticylinderedge(r=r,l=v[2],$fn=20);
        translate([r,r,v[2]]) rotate([0,0,180])
        anticylinderedge(r=r,l=v[2],$fn=20);
        translate([v[0]-r,r,v[2]]) rotate([0,0,270])
        anticylinderedge(r=r,l=v[2],$fn=20);

    };
}
                                              
module t(t, s = 18, style = "") {
    linear_extrude(height = letter_depth)
      text(t, size = s, font = str("Liberation Serif", style), $fn = 16,halign = "center",valign="center");
}

module everything(){
withInsets(["A","B","C","D","E"],[1,2,3,4,5,6],2,3);

translate([200,0,0])
withInsets(["A","B","C","D","E"],[7,8,9,10,11,12],4,3);

translate([0,-150,0])
withInsets(["F","G","H","I"],[1,2,3,4,5,6],1,2);

translate([200,-150,0])
withInsets(["F","G","H","I"],[7,8,9,10,11,12],1,4);
}

difference(){
everything();
//withInsets(["A","B"],[1,2],3,2);
//    translate([0,-300,5])
//    cube([300,300,10]);
}