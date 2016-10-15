
$fn = 100;



difference() {
    translate([0, 0, 16])
    rotate([0, 180,0]) {
        difference() {
            cylinder(r1=90/2, r2=40/2,h=25); // the barnacle!
                
            // bore center
            translate([0, 0, -0.1])
           // flowerpot
            cube([12.5, 6.5,200], center=true);
 


            // flatten top
            translate([0, 0, 16])
                cylinder(r=40,h=20);
            
            // inner space
            difference() {
                union() {
                    
                    translate([0, 0, -3.2])
                        cylinder(r1=90/2, r2=40/2,h=25);
                
                     rotate([0, 180,0]) {
                    translate([0, 0, -16]) {
                        for (rot = [45 : 30 : 405]) {
                            rotate([0, 0, rot]) {
                                translate([22, 0, -2])
                                rotate([0, -45, 0])
                                    cube([80, 10,5], center=true);
                                translate([38, 0, 14])
                                rotate([0, -45, 0])                                
                                    cube([13, 15,5], center=true);
                                
                            }
                        }
                    }
                    }
                }
                // cut off bottom of inner volume
                translate([0, 0, 15])
                    cylinder(r=100, h=100);
            }

 

            
        
    
    
    // the slots 
    translate([0, 0, -16]) {
        for (rot = [0 : 30 : 360]) {
            rotate([0, 0, rot]) {
                translate([28, 0, -2])
                rotate([0, -45, 0])
                    cube([80, 3,5], center=true);
            }
        }
    }
    
}
}
}



// screw posts
module screw_post () {
    difference() {
        intersection() {
            // post itself
            union() {
                translate([34, 0, 7]) {
                    cylinder(r=2.5, h=9);
                    translate([6, 0, 3])
                        cube([12, 4, 12], center=true);
                }
            }

            translate([0, 0, 16])
            rotate([0, 180,0])    
            translate([0, 0, -3.2])
                cylinder(r1=90/2, r2=40/2,h=25);
        }
        
        // screw hole
        translate([34, 0, 3])
            cylinder(r=2.55/2, h=20);        
    }
}

/*
// plate everything sits on
difference() {
    translate([0, 0, 2]) 
        cylinder(r=28, h=0.5);

           // flowerpot slot
            cube([20, 5,200], center=true);
}
*/
screw_post();

rotate([0, 0, 180])
    screw_post();




/*
// the stalk!

color("red")
difference() { // drill wire hole
    union() {
        // bottom connector
        translate([0, 0, -30])
            cube([12, 4,30], center=true);
        hull() {
            translate([0, 0, -20])
                cube([12, 7,0.1], center=true); // wide part of clip
            translate([0, 0, -15])
                cube([12, 4,1], center=true); // thin part of clip
        }

        // top connector
        rotate([0, 180, ]) {

            hull() {
                translate([0, 0, 45])
                    cube([12, 7,0.1], center=true);
                translate([0, 0, 50])
                    cube([12, 4,1], center=true);
            }
        }

        // modesty plate
        translate([0, 0, -23.5])
            cube([12, 16,3], center=true);
        
        // top plate
        translate([0, 0, -40])
            cube([12, 10,3], center=true);        
    }
    
    // driled hole
    translate([0, 0, -100])    
        cube([8, 1.5,200], center=true);        
}


// flower
difference() {
    union() {
        translate([0, 0, -57]) 
        for (rot = [0 : 30 : 360]) {
            rotate([0, 0, rot]) {
                translate([28, 0, -2])
                scale([2, 1, 1])
                rotate([0, 0, 45])     
                    cube([10, 10,2], center=true);
            }
        }
        translate([0, 0, -60]) 
            cylinder(r=31, h=2);
    }
    
    translate([0, 0, -58]) 
    for (rot = [0 : 30 : 360]) {
        rotate([0, 0, rot]) {
            translate([28, 0, -2])
            scale([2, 1, 1])
            rotate([0, 0, 45])     
                cube([8, 8,2], center=true);
        }
    }
}

*/