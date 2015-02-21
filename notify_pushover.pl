# Category=Home_Network
#
#@ Sends Notification message to Pushover

use strict;
use HTTP::Request::Common qw(POST);  
use LWP::UserAgent;

$v_notify_pushover = new  Voice_Cmd("Test Pushover Notify");

if ($Startup) {
        # Notify the on startup / restart
        print_log("System Restarted, Notifying Pushover") if $Debug{pushover};
        notify_pushover("System Restarted", "Misterhouse has been restarted");
}

if (said $v_notify_pushover) {
        # Send a test notification
        print_log("Sending test notification") if $Debug{pushover};
        notify_pushover("Test Notification", "This is a test notification!!");
}

sub notify_pushover {
        my ($title, $text, $priority) = @_;

        unless($config_parms{pushover_app_token}){
                print_log("pushover_app_token has not been set in mh.ini, Unable to notify pushover.");
                return;
        }

		unless($config_parms{pushover_user_key}){
                print_log("pushover_user_key has not been set in mh.ini, Unable to notify pushover.");
                return;
        }
	
        print_log("Sending notification to Pushover") if $Debug{pushover};
		
	my $url = "https://api.pushover.net/1/messages.json";
	
	my $ua = LWP::UserAgent->new();  
	my $req = POST $url, [ 
	 token => $config_parms{pushover_app_token},
	 user => $config_parms{pushover_user_key},
	 message => $text,
	 title => $title,
	 priority => $priority,
	 expire	=> 3600,
	 retry => 300,
	]; 
	my $content = $ua->request($req)->as_string; 

}
