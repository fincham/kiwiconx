
$fn = 100;

difference() {
    translate([0, 0, 16])
    rotate([0, 180,0]) {
        difference() {
            cylinder(r1=90/2, r2=40/2,h=25); // the barnacle!
                
            // bore center
            translate([0, 0, -0.1])
                cylinder(r=20,h=200);

            // flatten top
            translate([0, 0, 16])
                cylinder(r=40,h=20);
            
            // inner space
            difference() {
                translate([0, 0, -5])
                    cylinder(r1=90/2, r2=40/2,h=25);
                
                // cut off bottom 5mm
                translate([0, 0, 12])
                    cylinder(r=100, h=5);
            }
        }
    }
    
    // the slots 
    translate([0, 0, 0]) {
        for (rot = [0 : 30 : 360]) {
            rotate([0, 0, rot]) {
                translate([28, 0, -2])
                rotate([0, -45, 0])
                    cube([80, 3,5], center=true);
            }
        }
    }
    
 
}

difference() {
    // middle ring
    difference() {
        cylinder(r=10, h=5.1);
        translate([0, 0, -1])
            cylinder(r=8, h=10);
    }
    
    // cutouts
    cube([30, 2, 10], center=true );
    cube([2, 30, 10], center=true );
    
}

// screw posts
module screw_post () {
    difference() {
        intersection() {
            // post itself
            union() {
                translate([28, 0, 7]) {
                    cylinder(r=4, h=9);
                    translate([6, 0, 3])
                        cube([12, 8, 12], center=true);
                }
            }

            translate([0, 0, 16])
            rotate([0, 180,0])    
            translate([0, 0, -5])
                cylinder(r1=90/2, r2=40/2,h=25);
        }
        
        // screw hole
        translate([28, 0, 3])
            cylinder(r=1.5, h=20);        
    }
}

// plate everything sits on
translate([0, 0, 5]) 
    cylinder(r=31, h=2);

screw_post();

rotate([0, 0, 180])
    screw_post();