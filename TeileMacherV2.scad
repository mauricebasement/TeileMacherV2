//TeileMacher V2
$fn=50;
xCOff=5;
zRodRadius=2.5;

module profile(hole=false) {
    import("dxf/profile.dxf");
    if(hole==false)circle(r=2.5);
}
module zMotorRaw() {
    for(i=[0,30])translate([i,0])circle(r=2.5);
    translate([-31,0])rotate(a=[0,0,90])motor(screw_i=true,hole=true);
}
module zMotor() {
    difference() {
        offset(r=10)hull()zMotorRaw();
        zMotorRaw();
    }
}
l=120;
w=80;
module nutCover(nut=false) {
    difference() {
        square(28,center=true);
        tr_xy(x=10)circle(r=1.5);
        circle(r=zRodRadius);
        if(nut==true)circle(r=2*zRodRadius*0.9+1.02,$fn=6);
    }
}

module xCarriageRaw(nut=false,face=false,motor=true,rods=false) {
    offset(r=0.2)profile();
    translate([-34,0]) {
        circle(r=2.5);
        if(motor==true)rotate(a=[0,0,90]) {
            motor(screw_i=true,hole=true);
            if(face==true)motor(face=true);
        }
    }  
    translate([31.5,0]){
        circle(r=zRodRadius);
        if(nut==true)circle(r=2*zRodRadius*0.9+1.02,$fn=6);
        tr_xy(x=10)circle(r=1.5);
    }
    
    translate([0,0])tr_xy(x=l/2-5,y=w/2-5)circle(r=1.5);
    if(rods==true)for(i=[1,-1])translate([10,i*27])square([l,8],center=true);
}
module carriageSheet() {
    square([l,w],center=true);
}
module xCarriage1() {
    difference() {
        carriageSheet(nut=true);
        xCarriageRaw();
    }   
}
module xCarriage2() {
    difference() {
        carriageSheet();
        xCarriageRaw(face=true,,rods=true);
    }   
}
module xCarriage3() {
    difference() {
        carriageSheet();
        xCarriageRaw(face=true,nut=true);
    }   
}
module xCarriage4() {
    difference() {
        carriageSheet();
        xCarriageRaw(motor=false,nut=true,side=true);
    }   
}
module xCarriage5() {
    difference() {
        carriageSheet();
        xCarriageRaw(motor=false,side=true,rods=true);
    }   
}
module xCarriage6() {
    difference() {
        carriageSheet();
        xCarriageRaw(motor=false,side=true,nut=true);
    }   
}
module angle(profileSize=20,length=60,holeRadius=2.5,number=1,x=0) {
i=profileSize/2;
j=length-profileSize/2;
	difference() {
		hull()union() {
			square([profileSize,length]);
			square([length,profileSize]);
		}
		for(k=[i:((j-i)/number):(j+((j-i)/number))])translate([k,i])circle(r=holeRadius);
		for(k=[i:((j-i)/(number+x)):(j+((j-i)/(number+x)))])translate([i,k])circle(r=holeRadius);
	}
}
    
module motor(face,cable,screw_e,screw_i,hole,screw_d,screws,rod,a=1) {	
	if (face==true) square(42.5,center=true);
	if (cable==true) translate([21+5,0])square(10,center=true);
	if (screw_e==true) for(x=[1:4])rotate(a=[0,0,x*90])translate([26,26])circle(r=1.5);
	if (screw_i==true) for(x=[15.5,-15.5])for(y=[-15.5,15.5])translate([x,y])slot_hole(r=1.5,d=a);
	if (hole==true) circle(r=11);
	if (rod==true) circle(r=4);
	if (screws==true) for(x=[1:4])rotate(a=[0,0,x*90])translate([screw_d,screw_d])circle(r=1.5);
}
module slot_hole(r,d) {
	hull() {
		for(i=[-1,1])translate([0,i*d])circle(r=r);
	}
}
module tr_xy(x,y=0) {
	if(y==0) {
		for(i=[-1,1])for(j=[-1,1])translate([x*i,x*j])children();
	} else {
		for(i=[-1,1])for(j=[-1,1])translate([x*i,y*j])children();
	}
}

zMotor(); //2
xCarriage1(); //1
xCarriage2(); //1
xCarriage3(); //1
xCarriage4(); //1
xCarriage5(); //1
xCarriage6(); //1
nutCover(); //2
nutCover(nut=true); //2
angle();
angle(x=1);