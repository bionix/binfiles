#!/usr/bin/perl
#
# This perl script colorizes the dmesg output
#
use strict;
use warnings;

exec 'dmesg', @ARGV if grep /^-[rn]$/, @ARGV;

use constant {
  KERN_EMERG    => 0,
  KERN_ALERT    => 1,
  KERN_CRIT     => 2,
  KERN_ERR      => 3,
  KERN_WARNING  => 4,
  KERN_NOTICE   => 5,
  KERN_INFO     => 6,
  KERN_DEBUG    => 7,

  KERN_LAST     => 9,
};

use Term::ANSIColor qw(:constants);

sub do_exit ($)   { exit($_[0] >> 8) }
sub abort ($$) { print STDERR $_[1]; do_exit($_[0]) }

open DMESG, '-|', join(' ', 'dmesg -r', @ARGV)
  or abort($?, "Pipe failed.\n");

my $msgcolor;

while(<DMESG>) {
  /^</ or print && next;

  my ($level, $rts, $msg) = /^<(\d+)>(\[[.\s\d]+\])?(.*)$/;

  if($level > KERN_LAST) {
    ;
  } elsif($level > KERN_INFO) {
    $msgcolor = BOLD.BLACK;
  } elsif($level == KERN_WARNING) {
    $msgcolor = YELLOW;
  } elsif($level == KERN_ERR) {
    $msgcolor = BOLD.YELLOW;
  } elsif($level == KERN_CRIT) {
    $msgcolor = RED;
  } elsif($level <= KERN_ALERT) {
    $msgcolor = BOLD.RED;
  } else {
    $msgcolor = '';
  }

  no warnings qw(uninitialized);
  print BOLD, BLACK, $rts, RESET, $msgcolor, $msg, "\n";
}

close DMESG;

do_exit($?);
