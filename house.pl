# Category=Insteon

if ($state = state_now $Family_Room_Main_Pot_Lights) {
   print_log("FAMILY ROOM MAIN POT LIGHTS: $state");
   if ($state eq 'on_fast') {
      print_log("********** ON FAST");
   } elsif ($state eq 'on') {
      print_log("********** ON");
      #$kpl_A->set(ON);

   } elsif ($state eq 'off_fast') {
      print_log("********** FAST OFF");
   } elsif ($state eq 'off') {
      print_log("********** OFF");
      #$kpl_A->set(OFF);

   } else{
      print_log("********** UNKNOWN");
   }
}

if ($state = state_now $Front_Door_Keypad_D) {
   print_log("getting status of garage");
  
   $Garage_Door_Left->request_status(); 
   print_log("garage Left: " . $Garage_Door_Left->state_log());

   $Garage_Door_Right->request_status();
   print_log("garage Right: " . $Garage_Door_Right->state_log());
}


if ($state = state_now $Upstairs_Landing_Keypad_D){
	$main_floor_off->set(OFF);
}

if ($state = state_now $Upstairs_Landing_Keypad_C){
	$Family_Room_Main_Pot_Lights->set(OFF);
	$Family_Room_Fireplace_Pot_Lights->set(OFF);
	$Family_Room_Window_Pot_Lights->set(OFF);
}

if ($state = state_now $Front_Door_Keypad_E) {
   print_log("Front_Door_Keypad_E: $state");

my $ref = get_set_by $Front_Door_Keypad_E;
        print_log "Keypad E  button's was set to $state by $ref->{object_name}";

   if ($state eq 'on_fast') {
      print_log("********** E ON FAST");
   } elsif ($state eq 'on') {
      print_log("********** E ON");
   } elsif ($state eq 'off_fast') {
      print_log("********** E FAST OFF");
   } elsif ($state eq 'off') {
      print_log("********** E OFF");
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
      print_log("********** ON FAST");
		$Laundry_Room_Lights->set(ON);
   } elsif ($state eq 'on') {
      print_log("********** ON");
   } elsif ($state eq 'off_fast') {
      print_log("********** FAST OFF");
	$Laundry_Room_Lights->set(OFF);
   } elsif ($state eq 'off') {
      print_log("********** OFF");
   } else{
      print_log("********** UNKNOWN");
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

if ($state = state_now $Upstairs_Landing_Keypad_C) {
   if ($state eq 'on') {
      set $All_Lights OFF;
      set $Upstairs_Landing_Keypad_C OFF;
   }
}

if ($state = state_now $Upstairs_Landing_Keypad_B) {
   if ($state eq 'on') {
      set $Family_Room_Fireplace_Pot_Lights OFF;
      set $Upstairs_Landing_Keypad_B OFF;
   }
}


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


