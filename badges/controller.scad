include <non-printing-parts.scad>

// wemos is 26x36x0.95ish

$fn = 100;

module lid() {
    union() {
        difference() {
            translate([0, 0, 0.95])
                cube([29.52, 77, 2]);

            translate([1.5, 0, 0])
            scale(1.02)
                wemos();
        }
        translate([24.52, 36, -2])
            cube([3,3,2]);
        translate([24.52, 37, 0])
            cube([3,2,2]);    
        translate([2, 37, 0])
            cube([3,2,2]);        
        translate([2, 36, -2])
            cube([3,3,2]);    
    }
    
    // heat stakes
    translate([3, 60, -3])
        cylinder(r=0.8, h=5);
    translate([17, 60, -3])    
        cylinder(r=0.8, h=5);
    translate([3, 75, -3])
        cylinder(r=0.8, h=5);
    translate([17, 75, -3])    
        cylinder(r=0.8, h=5);
    
}

module box() {
    difference() {
        cube([36, 82, 15]); // positive box
        translate([2, 2, 13]) // lip
            cube([32, 78, 15]);        
        translate([3, 3, 2]) // box inner
            cube([30, 76, 15]);
    }
}

translate([2, 2, 25])
    lid();
box();