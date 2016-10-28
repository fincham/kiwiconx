$fn = 100;

include <circuit.scad>;

module ring_holder() {
    difference() {
        cylinder(r=18.68+1.15, h=3.5);
        translate([0, 0, -0.001])
        cylinder(r=18.68, h=10);
        translate([-5, -25, 0])
            cube([10, 50, 10]);
    }
}

module flora_holder() {
    difference() {
    union (){
    difference() {

            cylinder(r=7.18+1.15, h=3.5); 

      
        
        
        translate([0, 0, -0.001])
        cylinder(r=7.18, h=10);

    }

            difference() {
            cylinder(r=7.18+1.15, h=2);
            translate([0, 0, -0.001])
                cylinder(r=5, h=10);
            }  
        } 
        translate([-5, -25, 0])
            cube([10, 50, 10]);
    }
}

// dish top         
difference() {
    translate([0, 0, 15.01])
        cylinder(r=28, h=1, $fn=12); // dish itself

    translate([0, 0, -0.1])
        cube([6.5, 6.5, 200], center=true); // flower stem connector
    

}

// the dish
difference() {
    
    union() {
        cylinder(r1=45, r2=20, h=25, $fn=12); // dish itself
        
        difference() {
            // raised area around slots
            for (rot = [0 : 30 : 360]) {
                rotate([180, 0, rot]) {
                    translate([40.8, 0, -2])
                    rotate([45, -45, 0])
                        cube([80, 6,6], center=true);
                }
            } 
     
            translate([0, 0, -50]) 
                cylinder(r=200, h=50, $fn=50); // cut top off
    
        }
    }
    
    
    translate([29.6, -38.7, -0.01])
    rotate([0, 0, 45])
        cube([13,20,4.5]);
        
    translate([0, 0, -2])
        cylinder(r1=45, r2=20, h=25, $fn=12); // space inside the dish
    
    translate([0, 0, 16]) 
        cylinder(r=50, h=50, $fn=50); // cut top off
    
    // the slots 
    for (rot = [0 : 30 : 360]) {
        rotate([180, 0, rot]) {
            translate([45.8, 0, -2])
            rotate([0, -45, 0])
                cube([80, 3,5], center=true);
        }
    }
        

    
}




// overhang supports
intersection() {
    cylinder(r1=45, r2=20, h=25, $fn=12); // dish itself

    union() {
        translate([-3.125-3, -30, 14])
            cube([3, 60, 1]);
        translate([3.125, -30, 14])
            cube([3, 60, 1]); 
        translate([-10-3, -30, 14])
            cube([3, 60, 1]);
        translate([10, -30, 14])
            cube([3, 60, 1]);
    }
}



// screw posts
module screw_post () {
    difference() {
        intersection() {
            // post itself
            union() {
                translate([35, 0, 0]) {
                    cylinder(r=2.7, h=20);
                    translate([0, -2, 0])
                        cube([12, 4, 12]);
                }
            }

            translate([0, 0, -1])
                cylinder(r1=45, r2=20, h=25, $fn=12); // space inside the dish
        }
        
        // screw hole
        translate([35, 0, -0.1])
            cylinder(r=2.85/2, h=20);        
    }
}

screw_post();

rotate([0, 0, 180])
    screw_post();

translate([0, 0, 15.999]) {
    
    ring_holder();
    
    flora_holder();
    
}