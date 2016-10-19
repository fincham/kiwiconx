$fn = 100;

include <circuit.scad>;

// dish top         
difference() {
    translate([0, 0, 15.01])
        cylinder(r=28, h=1, $fn=12); // dish itself

    translate([0, 0, -0.1])
        cube([12.5, 6.5, 200], center=true); // flower stem connector
    
    scale([2, 2, 1])
    translate([0, 0, 15.7])
        circuit(10);
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
        translate([-9.25, -30, 14])
            cube([3, 60, 1]);
        translate([6.25, -30, 14])
            cube([3, 60, 1]); /*
        translate([-30, 3.25, 14])
            cube([60, 3, 1]);  
        translate([-30, -6.25, 14])
            cube([60, 3, 1]);          */
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


// modesty plate
difference() {
    translate([-7.5, -9, 15])
        cube([15, 18, 3.5]);  
    
    translate([-6.55, -8.05, 14])
        cube([13.1, 16.1, 10.5]);
    
  
}