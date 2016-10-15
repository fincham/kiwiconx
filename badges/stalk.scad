

// the stalk!

difference() { // drill wire hole
    union() {
        translate([-6.5, -2, 0])
            cube([13, 4, 30]); // stalk


        hull() {
            translate([0, 0, 3])
                cube([13, 9, 0.1], center=true); // wide part of clip
            cube([13, 4, 1], center=true); // thin part of clip
        }


        // modesty plate
        translate([-6.5, -8, 4.1])
            cube([13, 16, 1.5]);
        
        /*
        // top plate
        translate([-6, -5, 60])
            cube([13, 10, 3], center=true);        */
    }
    
    // driled hole
    translate([0, 0, -0.1])    
        cube([10, 1.8,200], center=true);        
}
