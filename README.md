# homelab - scripts

## setup.sh
[syzkaller setup script](https://github.com/google/syzkaller/blob/master/docs/linux/setup_ubuntu-host_qemu-vm_x86-64-kernel.md)

## deploy.ps1
New-Item and New-VM Current license or ESXi version prohibits execution of the requested operation
```powershell
Test-Connection -Uploadpath C:\temp\ubuntu-16.04.3-desktop-amd64.iso -Targetfolder ISOs -Datastore fuzz -Server testserver -Username testuser -Password testpass 
```

# homelab - resources and configuration

Dell R720 8 x 3.5"
- iDRAC 7 Enterprise
- Intel(R) Xeon(R) CPU E5-2609 v2 @ 2.50GHz (4 core)
- 128GB DDR3 RAM (24 DIMM slots)
- PERC H710 Mini Raid controller
- 2 x Dell 750W PSU
- 4 x Dell 450 GB, 2 x Dell 600 GB SAS HDD
- Broadcom Gigabit Ethernet BCM5720

## General setup
[How to initialize and create a Virtual Disk (VD) with a PowerEdge RAID Controller (PERC)](https://www.dell.com/support/article/us/en/04/sln132532/how-to-initialize-and-create-a-virtual-disk--vd--with-a-poweredge-raid-controller--perc-?lang=en)

## General updates
[Tutorials to Update a PowerEdge](https://www.dell.com/support/article/us/en/04/sln300662/how-to-dell-server---tutorials-to-update-a-poweredge?lang=en)

[Bootable iso update](https://dell.app.box.com/v/BootableR720) - use idrac or lifecycle controller. idrac requires exe from support.dell.com.

Updating through lifecycle controller with f10 on startup. FTP server -> ftp.dell.com. Grabs all firmware updates.

## iDrac 7 Enterprise
[Updating Firmware through the iDRAC](https://www.dell.com/support/article/us/en/04/sln292363/poweredge-server--updating-firmware-through-the-idrac?lang=en)

[Updating DRAC Firmware wiki](http://en.community.dell.com/techcenter/systems-management/w/wiki/3206.updating-drac-firmware)

[Releases page](http://en.community.dell.com/techcenter/systems-management/w/wiki/12334.idrac8-home#releases)

## Embedded System Diagnostics
[Running The Embedded System Diagnostics](http://www.dell.com/support/manuals/us/en/19/poweredge-r720/720720xdom-v3/running-the-embedded-system-diagnostics?guid=guid-e44e5046-b06a-4e5e-870c-68cc3e129ddd&lang=en-us)

[PSA/ePSA Diagnostics error codes](http://www.dell.com/support/manuals/us/en/19/poweredge-vrtx/servers_tsg/psaepsa-diagnostics-error-codes?guid=guid-9afeed67-a47c-4afd-83d8-04301ebf3523&lang=en-us)

## VmWare
[ESXi flash media install](http://www.dell.com/support/manuals/us/en/19/vmware-esxi-6.x/esxiiigpub-v1/installing-esxi-on-flash-media?guid=guid-744e0c3c-3659-42ba-b495-43facc9984d4&lang=en-us)

[Dell-customized ESXi Embedded ISO image](http://www.dell.com/support/article/us/en/04/sln288152/how-to-download-the-dell-customized-esxi-embedded-iso-image?lang=en)

[Install ESXi from USB on Bare Metal PowerEdge Server](https://thebackroomtech.com/2017/09/26/install-esxi-usb-bare-metal-poweredge-server/)

[Configuring boot sequence to ESXi](http://www.dell.com/support/manuals/us/en/04/vmware-esxi-6.x/esxiiigpub-v1/configuring-boot-sequence-to-esxi?guid=guid-a768043c-c2db-4a93-b57b-41739240a3f6&lang=en-us)

[VMware vSphere PowerCLI 6.5.4](https://code.vmware.com/doc/preview?id=5975#/doc/index-all_cmdlets.html)