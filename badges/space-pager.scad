$fn = 100;

module seethru_bit(h) {
    width = 36;
    height = 26.4;
    radius = 3.5;

    hull() {
        translate([radius, radius, 0])
            cylinder(r=radius, h=h);
        translate([height-radius, width-radius, 0])
            cylinder(r=radius, h=h);    
        translate([radius, width-radius, 0])
            cylinder(r=radius, h=h);       
        translate([height-radius, radius, 0])
            cylinder(r=radius, h=h);     
    }   
}

module corner_mounted(height, width, h, radius) {
    difference() {
        cube([height, width, h]);
        
        translate([0, 0, -0.1]) {
            translate([radius, radius, 0])
                cylinder(r=radius, h=h+0.2);
            translate([height-radius, width-radius, 0])
                cylinder(r=radius, h=h+0.2);    
            translate([radius, width-radius, 0])
                cylinder(r=radius, h=h+0.2);       
            translate([height-radius, radius, 0])
                cylinder(r=radius, h=h+0.2);
        }
    }   
}


translate([4.3, 1.8, 0])
difference() {
    cube([34, 40, 5]);

    translate([1.22, 2, 4.5])
        seethru_bit(10);
}


corner_mounted(42.9, 43.6, 1.2, 1.5);