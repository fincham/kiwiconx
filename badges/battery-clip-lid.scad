



difference() {
    translate([0.5, -6, 1])
    cube([9, 39.5, 5]);
    
    
    translate([0, -3, -5])
    cube([10, 33, 10]);
    
translate([0, -3, 0])
    hull() {
        cube([10, 1, 5]);    
        translate([0, -2, 5])
            cube([10, 3, 0.01]);    

    }
    
translate([0, 34.5-5, 0])
    hull() {
        cube([10, 1, 5]);    
        translate([0, 0, 5])
            cube([10, 3, 0.01]);    

    }



}