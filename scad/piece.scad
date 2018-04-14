base_w = 20; //width of base
base_h = 4; //height of base (up to shoulder)
base_thick = 2; //width of walls of hollow part of base.
base_inset = 2.4; //height of internal void in base.
top_h = 2; //height of top, above top of base.
tol = 1; //difference in width of top bit vs base inset.
top_w = base_w-tol-base_thick*2;
inset_w = base_w - base_thick*2;
letter_depth = 0.6;
sep = 1;
cols = [1,2,3,4,5,6,7,8,9,10,11,12];
rows = ["A","B","C","D","E","F","G","H","I"];
text_fudge = -0.3;


module anticirclecorner(r){
    difference(){
        cube([r,r,r]);
        //translate([-r/2,-r/2,-r/2])
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

module blank_piece(){
union(){
    difference(){
        flat_bottomed_rounded_cube([base_w,base_w,base_h],1);
        translate([base_thick,base_thick,0])
        cube([inset_w,inset_w,base_inset]);

    };
    translate([base_thick+tol/2,base_thick+tol/2,base_h])
    flat_bottomed_rounded_cube([top_w,top_w,top_h],1,roundtop=false);
}
    
}                                                                                                                                                                                                                   

module piece(n){
difference(){
    blank_piece();
    translate([text_fudge + base_w/2,base_w/2,base_h+top_h-letter_depth])
    t(n,6,":style=Bold");
}
}

module t(t, s = 16, style = "") {
    linear_extrude(height = letter_depth)
      text(t, size = s, font = str("Liberation Serif", style), $fn = 16,halign = "center",valign="center");
}

module allKeys(){
for( ci =[0:len(cols)-1])
   for( ri =[0:len(rows)-1])
   {
       translate([ci*(base_w+sep),-ri*(base_w+sep),0])
       piece(str(cols[ci],rows[ri]));
   }

}

allKeys();