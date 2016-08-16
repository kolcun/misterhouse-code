#use Data::Dumper;

# Category=Insteon



#if ($state = state_now $Upstairs_Landing_Keypad_A){
#	if ($state eq 'on') {
#		$Front_Hall_Hall_Side->set("20%");
#		$Upstairs_Landing_Keypad_A->set(OFF);
#	}
#}

if ($state = state_now $Pool_Gas_Heater){
        if ($state eq 'on') {
		notify_pushover("Pool Heater On","Pool Heater turned on");
        }
}

#turn pool heater off - in case it gets forgotten
if (time_now("21:30")) {
	$Pool_Gas_Heater->set(OFF);	
}elsif (time_now("22:30")) {
        $Pool_Gas_Heater->set(OFF);
}elsif (time_now("23:45")) {
        $Pool_Gas_Heater->set(OFF);
}elsif (time_now("01:00")) {
        $Pool_Gas_Heater->set(OFF);
}


if ($state = state_now $Upstairs_Landing_Keypad_D){
	if ($state eq 'on') {
		print_log("running bed_time_2 on");
		$Master_Light->set(ON);
		$bed_time_2->set(ON);
		$Upstairs_Landing_Keypad_Light->set(OFF,"10s");
		$Family_Room_Window_Pot_Lights->set(OFF);
		$Upstairs_Landing_Keypad_D->set(OFF);
	}
}

##
# Set momentary times for the IOlinc devices (in tenths of a second)
# keep these commented out, otherwise the log fills up with garbage becaues they are set every loop
# unsure how to have code that runs only once at restart
##
#$Garage_Door_Right->set_momentary_time(2);
#$Garage_Door_Left->set_momentary_time(2);
#$Awning->set_momentary_time(2);
##


## Garage Door - CODE lines in the mht file create the _door and _sensor objects
#If open at 9pm close Mike garage door
if (time_now("21:00") && $Garage_Door_Left_Door->{state} eq 'open'){
	notify_pushover("Garage - Mike", "Was open, so closing at 9pm");
	$Garage_Mike->set(OFF);
}

#If open at 9pm close Diane garage door
if (time_now("21:00") && $Garage_Door_Right_Door->{state} eq 'open'){
        notify_pushover("Garage - Diane", "Was open, so closing at 9pm");
        $Garage_Diane->set(OFF);
}

#Notify on Mike garage door state change
if (state_changed $Garage_Door_Left_Door) {
	notify_pushover("Garage - Mike","$Garage_Door_Left_Door->{state}");
	if($Garage_Door_Left_Door->{state} eq 'open'){
		$Front_Door_Keypad_H->set(ON);
	}else{
		$Front_Door_Keypad_H->set(OFF);
	}
}

#Notify on Diane garage door state change
if (state_changed $Garage_Door_Right_Door) {
	notify_pushover("Garage - Diane","$Garage_Door_Right_Door->{state}");
	if($Garage_Door_Right_Door->{state} eq 'open'){
                $Front_Door_Keypad_G->set(ON);
        }else{
                $Front_Door_Keypad_G->set(OFF);
        }
}


#if($state = state_now $Master_Keypad_Light){
#        print_log("********** MASTERKEYPAD LIGHT :  $state");
#}
#if($state = state_now $Master_Keypad_B){
#	print_log("********** MASTERKEYPAD B :  $state");
#}
#
#if($state = state_now $Upstairs_Landing_Keypad_B){
#        print_log("********** LANDINGKEYPAD B : $state");
#}
#if($state = state_now $Upstairs_Landing_Keypad_Light){
#        print_log("********** LANDINGKEYPAD LIGHT : $state");
#}

#Button D Testing
#if ($state = state_now $Front_Door_Keypad_D) {
#   if ($state eq 'on_fast') {
#	print_log("D ON FAST");
#   } elsif ($state eq 'on') {
#	print_log("D ON normal");
#   } elsif ($state eq 'off_fast') {
#	print_log("D OFF FAST");
#   } elsif ($state eq 'off') {
#	print_log("D OFF normal");
#   }
#}


###
## Timers
###

#10 min exterior light on on_fast
my $extLight_Timer = new Timer;
if ($state = state_now $Front_Door_Keypad_Ext_Light) {
   if ($state eq 'on_fast') {
	notify_pushover("Outside Light","Outside Light Timer 10min");
	$Front_Door_Keypad_B->set(ON);
	$Front_Door_Keypad_Ext_Light->set(ON);
	$extLight_Timer->set(600);
   }
}

if (expired $extLight_Timer) {
	notify_pushover("Outside Light","Outside Light Timer expired");
  	$Front_Door_Keypad_Ext_Light->set(OFF);
	$Front_Door_Keypad_B->set(OFF);
}

#Powder Room Timer - turn off lights if left on for 20min
my $powderRoomTimer = new Timer;
if ('on' eq state_now $Powder_Room_Sconce || 'on' eq state_now $Powder_Room) {
	$powderRoomTimer->set(1200);
}  
if (expired $powderRoomTimer) {
	$Powder_Room_Sconce->set(OFF, "10s");
	$Powder_Room->set(OFF, "10s");
}


#Laundry Lights Trigger
if ($state = state_now $Laundry_Room_Lights){
	if ($state eq 'off_fast'){
		$Basement_Stairs_Top->set(OFF);
		$Laundry_Room_Hallway->set(OFF);
	}
	 if ($state eq 'on_fast'){
                $Basement_Stairs_Top->set(ON);
        }
}


if ($state = state_now $Basement_Stairs_Top) {
   if ($state eq 'on_fast') {
	$Laundry_Room_Lights->set(ON);
   } elsif ($state eq 'on') {
   } elsif ($state eq 'off_fast') {
	$Laundry_Room_Lights->set(OFF);
	$Laundry_Room_Hallway->set(OFF);
   } elsif ($state eq 'off') {
   } else{
   }
}

#sub sync_kpl_lights{
#    my ($ref_light, $kpl_scene) = @_;
#    # avoid unnecessary traffic, like a get_status where status hasn't changed.
#    if ($ref_light->state_changed) {
#        print_log "MYLOGKPL: sync_kpl_lights called for state_changed on ".
#            $ref_light->get_object_name." to ".$ref_light->state." for ".
#            $kpl_scene->get_object_name." set kpls in 1sec";
#        # delay is to avoid collisions. In case we're in this code path
#        # due to a remote toggle instead (you pushed the switch), that switch
#        # could already be running a scene and you don't want to conflict with it
#        # (for local state changes, this is not an issue).
#        $kpl_scene->set_with_timer('', 1, $ref_light->state);
#    }
#}


