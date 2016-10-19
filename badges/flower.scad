$fn = 100;

// flower
difference() {
    union() { // flower
        for (rot = [0 : 30 : 360]) {
            rotate([0, 0, rot]) {
                translate([28, 0, 1])
                scale([2, 1, 1])
                rotate([0, 0, 45])     
                    cube([10, 10, 2], center=true);
            }
        }
        
        cylinder(r=31, h=1.5);
    }
    
    translate([0, 0, 1]) // depressions
    for (rot = [0 : 30 : 360]) {
        rotate([0, 0, rot]) {
            translate([28, 0, 1])
            scale([2, 1, 1])
            rotate([0, 0, 45])     
                cube([8, 8, 3], center=true);
        }
    }
    
    translate([0, 0, -10])
        cube([12.5, 6.5, 200], center=true); // flower stem connector    
}


// neopixel holder
difference() {
    union() {
        difference() {
            cylinder(r=26/2,h=6);    
            cylinder(r=23.2/2,h=10);
        }
        
        cylinder(r=23.3/2, h=4.25);
    }
    
    translate([-5, -25, -0.1])
        cube([10, 50, 10]);    

    rotate([0, 0, 90])
    translate([-5, -25, -0.1])
        cube([10, 50, 10]);
}
