#!/usr/bin/perl

my $pwd = "/export/opt/src/sample/sample-cuda/hwtest";

my $gpuid = sprintf("%d",$ARGV[0]);
my $nloop = 5120; # 3min = 5120
#$nloop = 1;

my $hostname = `hostname`;
chomp($hostname);
my $logfile = "HWTEST.LOG.$hostname.$gpuid";

my $cmd = "$pwd/run.exe $gpuid $nloop ";

print "CMD: ".$cmd ."\n";
print "LOG: ".$logfile ."\n";

$| = 1; # fflush(STDOUT);

for(my $i=0; $i<99999999; $i++){
		my $s =  `$cmd`;
		print $s;
		open (LOG, ">>$pwd/log/$logfile");
		print LOG $s;
		close(LOG);
}


1;
