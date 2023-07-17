Prerequisites
-------------

Requires the following to have been installed:
- virtualbox
- vagrant

Using standard versions of these from Ubuntu Lunar Lobster host.


Summary of VMs in this solution
-------------------------------

"main": Ubuntu VM that demonstrates the problem (by running ping tests) 
"router_h": VM for sending 'high' preference default gateway router advertisements (uses bird2 for RA)
"router_m": VM for sending 'medium' preference default gateway router advertisements (uses bird2 for RA)

All three VMs are connected via an 'internal' network that is isolated from the host/physical network.


Steps to reproduce problem
--------------------------

1. Start VMs
    vagrant up
    Expected result: All 3 VMs are started, but sending of IPv6 router advertisements is initially disabled

2. Verify there is no IPv6 default gateway yet on 'main' VM (RA hasn't been enabled yet) 
    ./test-ping.sh
    Expected result: ping: connect: Network is unreachable

3. Enable Router Advertisements on 'high' preference default gateway (address ends with :1)
    ./enable-h.sh
    Expected result: radv_h: enabled

4. Verify 'high' preference default gateway (address ends with :1) is used for IPv6 pings from main VM
    ./test-ping.sh
    Expected result: From fd00:a:b:c::1 icmp_seq=1 Destination unreachable: No route
    (Note this response is from ":1" router.)

5. Enable Router Advertisements on 'medium' preference default gateway (address ends with :2)
    ./enable-m.sh
    Expected result: radv_m: enabled

6. Run test to see whether 'high' or 'medium' preference default gateway is used for IPv6 pings from main VM
    ./test-ping.sh
    Expected result: From fd00:a:b:c::1 icmp_seq=1 Destination unreachable: No route
    Actual result:   From fd00:a:b:c::2 icmp_seq=1 Destination unreachable: No route

Problem is that the most-recently-started router is being used even though it has lower preference level.
Correct behaviour would be to continue using the higher-preference router.


Note - occasionally the problem doesn't occur. (In that case, try again with fresh VMs: vagrant destroy -f; vagrant up)


Additionally, both 'default' routes show with the same preference level, but I would expect to see one with 'pref high' and one with 'pref medium':
$ ./show-route.sh
::1 dev lo proto kernel metric 256 pref medium
fd00:a:b:c::/64 dev enp0s8 proto ra metric 1024 expires 286sec pref medium
fe80::/64 dev enp0s3 proto kernel metric 256 pref medium
fe80::/64 dev enp0s8 proto kernel metric 256 pref medium
default proto ra metric 1024 expires 76sec pref high
    nexthop via fe80::1 dev enp0s8 weight 1
    nexthop via fe80::2 dev enp0s8 weight 1


Scripts
-------
These scripts can be run on the host, to control/interact with the VMs:

./enable-h.sh: enable 'high' preference router advertisements
./disable-h.sh: disable 'high' preference router advertisements (sends 0-lifetime RA to expire previous advertisements)
./enable-m.sh: enable 'medium' preference router advertisements
./disable-m.sh: disable 'medium' preference router advertisements (sends 0-lifetime RA to expire previous advertisements)
./test-ping.sh: send test ping from 'main' VM
./show-route.sh: show IPv6 route info from 'main' VM (runs 'ip -6 route' in main VM)
./show-journal.sh: show the journal for systemd-networkd from 'main' VM (has debug logging enabled)
./monitor-radv.sh: run radvdump on main VM to show router advertisements received by main VM (in realtime / needs to be left running for a while to show stuff)


Final cleanup
-------------

1. Stop/remove all VMs:
    vagrant destroy -f
