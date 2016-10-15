$fn = 100;

// screw hole
module screw_hole () {
        translate([35, 0, -0.1])
            cylinder(r=3/2, h=20);       
}

// the dish
difference() {
    cylinder(r=46, h=25, $fn=12); // dish itself
    
    // cut off top
    translate([0, 0, 1])
        cylinder(r=200, h=100, $fn=50);

    screw_hole();

    rotate([0, 0, 180])
        screw_hole();
}

