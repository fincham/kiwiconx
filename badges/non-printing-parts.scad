// NON-PRINTED MODULES

module battery() {
    union() {
        color("silver")
            cube([30, 43.25, 7]);
        translate([0, 43.249, 0])
            color("yellow")
                cube([30, 6.75, 7]);
    }
}

module wemos() {
        union() {
            color([0.26, 0.32, 0.6])
                cube([26, 36, 0.95]); // board
            
            translate([6.5, 13, 0.949]) 
            color("silver")
                cube([13, 15, 2.6]); // ESP8266
            
            translate([4.9, 12, 0.949])             
            color("black")
                cube([16.2, 24, 0.65]); // ESP8266 carrier
            
            translate([10, 0, -2.7])
                color("silver")
                    cube([7, 5.7, 2.7]); // USB             
        }
}

module charger() {
        union() {
            color([0.26, 0.32, 0.6])
                cube([19, 20, 1.55]); // board
            translate([5.5, 14, 0.949])
                color("black")
                    cube([8, 6, 5]); // JST
            translate([6, 0, 1.54])
                color("silver")
                    cube([7, 5.7, 2.7]); // USB             
        }
}