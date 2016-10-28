$fn = 100;

// screw hole
module screw_hole(where) {
        translate([where, 0, -0.1])
            cylinder(r=3/2, h=20);       
}

module posted_screw_hole(where) {
        difference() {
            translate([where, 0, 0])
                cylinder(r=3/2+1, h=5); 
            translate([where, 0, -0.1])
                cylinder(r=2.75/2, h=20);       
        }
}

module gemma_holder() {
    difference() {
        cylinder(r=15.3, h=3.5);
        cylinder(r=14.18, h=10);
        translate([-5, -25, 0])
            cube([10, 50, 10]);
    }
}

// heat stakes for the charger
module charger() {
    translate([0, 0, 0])
        cylinder(r=0.9, h=5);
    translate([14, 0, 0])    
        cylinder(r=0.9, h=5);
    translate([0, 15, 0])
        cylinder(r=0.9, h=5);
    translate([14, 15, 0])    
        cylinder(r=0.9, h=5);
}

// the dish
difference() {
    cylinder(r=46.5, h=25, $fn=12); // dish itself
    
    // cut off top
    translate([0, 0, 1])
        cylinder(r=200, h=100, $fn=50);

    screw_hole(35);

    rotate([0, 0, 180])
        screw_hole(35);
    
    screw_hole(30);

    rotate([0, 0, 180])
        screw_hole(30);
        
    // USB hole
    translate([31.5, -40, -0.2])
    rotate([0, 0, 45])    
        cube([12, 12, 10]);        

    translate([15.5, -31, -1])
    rotate([0, 0, 90+45])
        cube([15.5, 7.5, 5]);
}



posted_screw_hole(30);

rotate([0, 0, 180])
    posted_screw_hole(30);

translate([21, -31, 0])
rotate([0, 0, 45])
    charger();

translate([-15, -18, 0])
rotate([0, 0, 105])
gemma_holder();

// battery holder
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