
// flower
difference() {
    union() {
        translate([0, 0, -57]) 
        for (rot = [0 : 30 : 360]) {
            rotate([0, 0, rot]) {
                translate([28, 0, -2])
                scale([2, 1, 1])
                rotate([0, 0, 45])     
                    cube([10, 10,2], center=true);
            }
        }
        translate([0, 0, -60]) 
            cylinder(r=31, h=2);
    }
    
    translate([0, 0, -58]) 
    for (rot = [0 : 30 : 360]) {
        rotate([0, 0, rot]) {
            translate([28, 0, -2])
            scale([2, 1, 1])
            rotate([0, 0, 45])     
                cube([8, 8,2], center=true);
        }
    }
}

