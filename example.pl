

# Category=Insteon

my $stateButton = state_now $Front_Door_Keypad_E;


my $Test_Timer = new Timer;
if ($state = state_now $Front_Door_Keypad_C) {
   if ($state eq 'on') {
      set $Test_Timer 30;
      print_log("Test timer set");
      set $Front_Hall_Hall_Side 'on';
   } else {
      set $Test_Timer 0;
   }
}

if (expired $Test_Timer) {
   set $Front_Hall_Hall_Side 'off';
   print_log("TEST timer expired, turning off.");
}


if ($state = state_now $Front_Door_Keypad_D) {
   if ($state eq 'on') {
	print_log("D is on");
   }else {
	print_Log("D is off");
   }
}

if (new_second 10) {
 	print "\nanother 10 seconds\n";
	print $stateButton;
	print_log(state_now $Front_Hall_Hall_Side);
	$Front_Hall_Hall_Side->set('40%');
	#$mbr_lt_mike->set(ON);
}

#if (new_second 5) {
#        print "\nTesting Light Off\n";
#        #$mbr_lt_mike->set(OFF);
#}

# print hi and give uptime every 5 seconds
#if ($New_Second and !($Second % 5)) {
#    my $uptime_pgm = &time_diff($Time_Startup_time, time);
#    my $uptime_computer = &time_diff(0, (get_tickcount)/1000);
#    print_log "Hi, I was started $uptime_pgm ago. The computer was booted $uptime_computer ago.\n";
#}

