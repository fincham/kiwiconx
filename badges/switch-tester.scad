$fn = 200;

difference() {
    cube([15, 15, 3]);
    
    translate([4.41, 4.41, 0.25])
        cube([6.18, 6.18, 10]);
    
    translate([7.5, 7.5, -1])
        cylinder(r=2, h=10);
}