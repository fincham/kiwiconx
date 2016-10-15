

// the stalk!

difference() { // drill wire hole
    union() {
        translate([-6, -2, 0])
            cube([12, 4, 10]); // stalk


        hull() {
            translate([0, 0, 3])
                cube([12, 7, 0.1], center=true); // wide part of clip
            cube([12, 4, 1], center=true); // thin part of clip
        }


        // modesty plate
        translate([-6, -8, 4])
            cube([12, 16, 1.5]);
        
        /*
        // top plate
        translate([-6, -5, 60])
            cube([12, 10, 3], center=true);        */
    }
    
    // driled hole
    translate([0, 0, 100])    
        cube([8, 1.5,200], center=true);        
}
