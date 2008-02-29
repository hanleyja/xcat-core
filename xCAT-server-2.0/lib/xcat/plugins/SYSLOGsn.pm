#!/usr/bin/env perl
# IBM(c) 2007 EPL license http://www.eclipse.org/legal/epl-v10.html
#-------------------------------------------------------
package xCAT_plugin::SYSLOGsn;
use xCAT::Table;

use xCAT::Utils;

use xCAT::MsgUtils;
use Getopt::Long;

#-------------------------------------------------------

=head1 
  xCAT plugin package to setup SYSLOG 


#-------------------------------------------------------

=head3  handled_commands 

Check to see if on a Service Node
Call  setup_SYSLOG

=cut

#-------------------------------------------------------

sub handled_commands

{
    my $rc = 0;
    if (xCAT::Utils->isServiceNode())
    {
        my $service = "syslog";

        # service needed on this Service Node
        $rc = &setup_SYSLOG();    # setup SYSLOG
        if ($rc == 0)
        {
            xCAT::Utils->update_xCATSN($service);
        }
    }
    return $rc;
}

#-------------------------------------------------------

=head3  process_request 

  Process the command

=cut

#-------------------------------------------------------
sub process_request
{
    return;
}

#-----------------------------------------------------------------------------

=head3 setup_SYSLOG 

    Sets up SYSLOG 

=cut

#-----------------------------------------------------------------------------
sub setup_SYSLOG
{
    my $rc = 0;
    if (-e "/etc/syslog.conf")
    {
        my $cmd = "grep *.debug /etc/syslog.conf";
        xCAT::Utils->runcmd($cmd, -1);
        if ($::RUNCMD_RC != 0)
        {    # need to add
            ` echo "*.debug   /var/log/messages" >> /etc/syslog.conf`;
            `echo "*.crit   /var/log/messages" >> /etc/syslog.conf`;
            `service syslog restart`;
        }
    }

    return $rc;
}
1;
