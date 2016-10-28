
translate([-2.5,-7, 0])
cube([15,40,1]);

// battery holder
/*translate([0, -5, 0])
    cube([10, 3, 5]);

translate([0, 33-5, 0])
    cube([10, 3, 5]);*/
    
translate([0, -3, 0])
    hull() {
        cube([10, 1, 5]);    
        translate([0, -2, 5])
            cube([10, 3, 0.01]);    

    }
    
translate([0, 33-5, 0])
    hull() {
        cube([10, 1, 5]);    
        translate([0, 0, 5])
            cube([10, 3, 0.01]);    

    }