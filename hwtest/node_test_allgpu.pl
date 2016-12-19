#!/usr/bin/perl

my $pwd = "/export/opt/src/sample/sample-cuda/hwtest";

my $nloop = 5120; # 3min = 5120
#$nloop = 1;

my $hostname = `hostname`;
chomp($hostname);
my $logfile = "HWTEST.LOG.$hostname";

my @cmd;
$cmd[0] = "$pwd/run.exe 0 $nloop ";
$cmd[1] = "$pwd/run.exe 1 $nloop ";
$cmd[2] = "$pwd/run.exe 2 $nloop ";
$cmd[3] = "$pwd/run.exe 3 $nloop ";

print "CMD: ".$cmd[0] ."\n";
print "CMD: ".$cmd[1] ."\n";
print "CMD: ".$cmd[2] ."\n";
print "CMD: ".$cmd[3] ."\n";
print "LOG: ".$logfile ."\n";

$| = 1; # fflush(STDOUT);

for(my $i=0; $i<99999999; $i++){
		for(my $gid=0; $gid<4; $gid++){
				my $c = $cmd[$gid];
				my $s =  `$c`;
				print $s;
				open (LOG, ">>$pwd/log/$logfile");
				print LOG $s;
				close(LOG);
		}
}


1;
