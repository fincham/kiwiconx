include <circuit.scad>;

module clip() {
    hull() {
        translate([0, 0, 3])
            cube([13, 9, 0.1], center=true); // wide part of clip
        cube([13, 4, 1], center=true); // thin part of clip
    }
}    

// the stalk!
difference() { // drill wire hole
    union() {
        translate([-6.5, -2, 0])
            cube([13, 4, 65]); // stalk

        // bottom clip
        clip();

        // modesty plate
        translate([-6.5, -8, 4.25])
            cube([13, 16, 1.5]);
        

        // top plate
        translate([-6.5, -8, 60])
            cube([13, 16, 1.5]);
        
        // top clip
        translate([0, 0, 63+1.5+1.25])
        rotate([0, 180, 0])
            clip();
    }
    
    // driled hole
    translate([0, 0, -0.1])    
        cube([10, 1.6,200], center=true);        
    
    // some "art" for the side
    /* intersection() {
        translate([-6.5, -2, 5])
            cube([13, 4, 55]); // stalk
        
        translate([0, 2.8, 30])
        rotate([90, 0, 0])
        scale([1.5, 2, 1])
            circuit(1);
    } */
}

