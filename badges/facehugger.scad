// the "face hugger"

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
            translate([7, 13, 0.949]) {
                color("silver")
                    cube([13, 15, 2.6]); // ESP8266 
                color("black")
                    cube([13, 23, 0.3]); // ESP8266 carrier
            }
            translate([9.5, 0, -2.7])
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

// PRINTED SLED COMPONENTS

module wemos_grabber(depth) {
    union() {
        cube([2, 5, 11]);
        translate([-2-depth, 0, 8])
            difference() {
                cube([depth+2, 5, 3]);
                translate([-3, -1, 1])
                    cube([depth+4, 7, 0.96]);
            }

    }
}

module charger_grabber(depth, slot) {
    union() {
        cube([2, 5, 11.5]);
        translate([-2-depth, 0, 8])
            difference() {
                cube([depth+2, 5, 3.5]);
                translate([-3, -1, 1])
                    cube([slot+4, 7, 1.5]);
            }

    }
}

module sled() {
    // bottom plane
    cube([33, 56, 1]);

    // wemos grabbers
    translate([2, 36, 0]) // top left
    rotate([0, 0, 180])
        wemos_grabber(4);
    translate([31, 31, 0]) // top right
        wemos_grabber(4);    
    translate([31, 0, 0]) // bottom right
        wemos_grabber(0.5);
   
    // charger grabbers 
    translate([31, 37, 0]) // bottom right
        charger_grabber(4, 4.1);      
    translate([31, 51, 0]) // top right
        charger_grabber(4, 4.1);
    rotate([0, 0, 180]) {    
        translate([-2, -56, 0]) // top left
            charger_grabber(12, 4);      
        translate([-2, -42, 0]) // bottom left
            charger_grabber(12, 4);
    }

    // fillets
    
}

preview = 0;

if (preview) {
    translate([1.5, 6.5, 1.1])
        battery();

    translate([3.5, 0, 9])
        wemos();

    translate([31.5, 37, 9])
    rotate([0, 0, 90])
        charger();
}

sled();
