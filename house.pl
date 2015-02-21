# Category=Insteon

#if ($state = state_now $Family_Room_Main_Pot_Lights) {
#   print_log("FAMILY ROOM MAIN POT LIGHTS: $state");
#   if ($state eq 'on_fast') {
#      print_log("********** ON FAST");
#   } elsif ($state eq 'on') {
#      print_log("********** ON");
#      #$kpl_A->set(ON);
#
#   } elsif ($state eq 'off_fast') {
#      print_log("********** FAST OFF");
#   } elsif ($state eq 'off') {
#      print_log("********** OFF");
#      #$kpl_A->set(OFF);
#
#   } else{
#      print_log("********** UNKNOWN");
#   }
#}


if ($state = state_now $Upstairs_Landing_Keypad_A){
	if ($state eq 'on') {
		$Front_Hall_Hall_Side->set("20%");
		$Upstairs_Landing_Keypad_A->set(OFF);
	}
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

if ($state = state_now $Front_Door_Keypad_E) {
   print_log("Front_Door_Keypad_E: $state");

my $ref = get_set_by $Front_Door_Keypad_E;
        print_log "Keypad E  button's was set to $state by $ref->{object_name}";

   if ($state eq 'on_fast') {
      print_log("********** E ON FAST");
   } elsif ($state eq 'on') {
      print_log("********** E ON");

$io_device_sensor = new Insteon::IOLinc_sensor($Garage_Door_Right);
if ($io_device_sensor->state eq OFF){
    print_log("Garage door right - sensor is off");
}elsif ($io_device_sensor->state eq OFF){
    print_log("Garage door right - sensor is on");
}else{
    print_log("Garage door right - sensor unknown");
}

notify_pushover("Button E on","Button E notification test");

   } elsif ($state eq 'off_fast') {
      print_log("********** E FAST OFF");
   } elsif ($state eq 'off') {
      print_log("********** E OFF");
   }
}

#Front door Keypad Button B
if ($state = state_now $Front_Door_Keypad_B) {
   if ($state eq 'on_fast') {
	print_log("Button B: on fast - sending pushover notification");
	notify_pushover("Button B","Button B notification test");
   } elsif ($state eq 'on') {
	print_log("Button B: Was turned on by:" . $Front_Door_Keypad_B->get_set_by());
   } elsif ($state eq 'off_fast') {
   } elsif ($state eq 'off') {
	print_log("Button B: Was turned off by:" . $Front_Door_Keypad_B->get_set_by());
   }
}

if($state = state_now $Front_Door_Keypad_C){
	print_log("front door button c pressed");
   if ($state eq 'on_fast') {
      print_log("********** C ON FAST");
   } elsif ($state eq 'on') {
      print_log("********** C ON");
	print_log("turning button d on");
	$Garage_Door_Right->request_sensor_status();
		
	#this just prints to the log, like so :   [Insteon::IOLinc] received status for $Garage_Door_Rightsensor of: on hops left: 0
	#not sure how to capture as variable
	# sensor on = door closed
	# sensor off = door open
	$Front_Door_Keypad_D->set(ON);

	$Front_Door_Keypad_B->set(ON, "button_c");
   } elsif ($state eq 'off_fast') {
      print_log("********** C FAST OFF");
   } elsif ($state eq 'off') {
      print_log("********** C OFF");
	print_log("turning button d off");
	$Front_Door_Keypad_D->set(OFF);
   }
}

#Button D Testing
if ($state = state_now $Front_Door_Keypad_D) {
   if ($state eq 'on_fast') {
	print_log("D ON FAST");
   } elsif ($state eq 'on') {
	print_log("D ON normal");
   } elsif ($state eq 'off_fast') {
	print_log("D OFF FAST");
   } elsif ($state eq 'off') {
	print_log("D OFF normal");
   }
}


#5 min exterior light on on_fast
my $extLight_Timer = new Timer;
if ($state = state_now $Front_Door_Keypad_Ext_Light) {
   if ($state eq 'on_fast') {
      print_log("********* EXT LIGHT timer started");
      set $extLight_Timer 300;
      $Front_Door_Keypad_F->set(ON);
   } else {
      set $extLight_Timer 0;
   }
}

if (expired $extLight_Timer) {
   $Front_Door_Keypad_Ext_Light->set(OFF);
   print_log("Ext Light  Timer expired, turning light off.");
   $Front_Door_Keypad_F->set(OFF);
}


#Garage Testing
if ($state = state_now $Front_Door_Keypad_H) {
   if ($state eq 'on_fast') {
     $Garage_Door_Right->set(ON);
     $Garage_Door_Left->set(ON);
   } elsif ($state eq 'on') {
     $Garage_Door_Left->set(ON);
   } elsif ($state eq 'off_fast') {
     $Garage_Door_Right->set(ON);
     $Garage_Door_Left->set(ON);
   } elsif ($state eq 'off') {
     $Garage_Door_Left->set(ON);
   }
}

#Garage Testing
if ($state = state_now $Front_Door_Keypad_G) {
   if ($state eq 'on_fast') {
     $Garage_Door_Right->set(ON);
     $Garage_Door_Left->set(ON);
   } elsif ($state eq 'on') {
     $Garage_Door_Right->set(ON);
   } elsif ($state eq 'off_fast') {
     $Garage_Door_Right->set(ON);
     $Garage_Door_Left->set(ON);
   } elsif ($state eq 'off') {
     $Garage_Door_Right->set(ON);
   }
}

#THIS DOES NOT WORK - can't ever seem to trigger based on state_now - except during a rescan - then it seems to show..???
if ($state = state_now $Garage_Door_Right){
	print_log("**GARAGE** garge door right - state_now");
	if ($state eq 'on') {
		#this means the garage is sensing closed
		print_log("**GARAGE** garage door right on - sensing closed");
		
	} elsif ($state eq 'off') {
		print_log("**GARAGE** garage door right off - sensing open");
	}else{
		print_log("**GARAGE** garage door right other state");
	}
}
#Laundry Lights Trigger
if ($state = state_now $Laundry_Room_Lights){
	if ($state eq 'off_fast'){
		$Basement_Stairs_Top->set(OFF);
	}
	 if ($state eq 'on_fast'){
                $Basement_Stairs_Top->set(ON);
        }
}


if ($state = state_now $Basement_Stairs_Top) {
   print_log("BASEMENT STAIRS: $state");
   if ($state eq 'on_fast') {
	$Laundry_Room_Lights->set(ON);
   } elsif ($state eq 'on') {
   } elsif ($state eq 'off_fast') {
	$Laundry_Room_Lights->set(OFF);
   } elsif ($state eq 'off') {
   } else{
   }
}


#MH doesn't like the update_flags - gives error - 'Can\'t locate object method "update_flags" via package "Inste.
#if ($state = state_now $Upstairs_Landing_Keypad_D) {
#   print_log("upstairs landing D state $state");
#   if ($state eq 'on_fast') {
#      print_log("onfast!");
#      $Upstairs_Landing_Keypad_D->update_flags('08'); #backlight off
#      set $Upstairs_Landing_Keypad_D OFF;
#   } elsif ($state eq 'on') {
#      print_log("just on");
#      $Upstairs_Landing_Keypad_D->update_flags('09'); #backlight on
#      set $Upstairs_Landing_Keypad_D OFF;
#   } 
#}


sub sync_kpl_lights{

    my ($ref_light, $kpl_scene) = @_;
    # avoid unnecessary traffic, like a get_status where status hasn't changed.
    if ($ref_light->state_changed) {
        print_log "MYLOGKPL: sync_kpl_lights called for state_changed on ".
            $ref_light->get_object_name." to ".$ref_light->state." for ".
            $kpl_scene->get_object_name." set kpls in 1sec";
        # delay is to avoid collisions. In case we're in this code path
        # due to a remote toggle instead (you pushed the switch), that switch
        # could already be running a scene and you don't want to conflict with it
        # (for local state changes, this is not an issue).
        $kpl_scene->set_with_timer('', 1, $ref_light->state);
    }
}


