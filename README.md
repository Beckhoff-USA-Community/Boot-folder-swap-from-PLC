# About This Repository
 
This is an example on how to use the TwinCAT variant manager, [_Boot folders](https://infosys.beckhoff.com/content/1033/variant_management/6325872779.html?id=1322548522019609004) and switch between a variant at runtime. 

# Background information:

When a TwinCAT project is successfully compiled, all necessary runtime files are stored in the solution folder under Solution -> TwinCAT project -> "_Boot".

Upon activation ![image](https://user-images.githubusercontent.com/19829308/220220768-bd583224-5e67-4282-ab9e-06754671e32a.png), the files in this folder are copied to the target's Boot folder (C:\TwinCAT\3.1\Boot) and then the TwinCAT system is restarted. 
After a restart, the TwinCAT system loads the files from the boot folder into memory and starts to execute them.

More information about this process is also found here [TwinCAT 3 | Machine update at file level](https://infosys.beckhoff.com/content/1033/tc3_grundlagen/10696055051.html?id=2628406925900354307).
 

# Summary of the code:

1. In the TwinCAT project two variants have been defined: RevA and RevB.
![image](https://user-images.githubusercontent.com/19829308/220223650-c548a18e-0d45-4502-a6cd-0b01545f2d53.png)

The difference in the two variants of this example is that RevA uses an EL2809-0000 and RevB uses an EL2809-0015. In RevA, the EL2809-0015 is disabled, while in RevB, the EL2809-0000 is disabled.

![image](https://user-images.githubusercontent.com/19829308/220224029-0dd8dd6d-9d3d-4ec4-a93c-3d8fad74f4c3.png)

Please see the [variant manager documentation](https://infosys.beckhoff.com/content/1033/variant_management/index.html?id=640168702518993771) for further details about features and workflow.

2. A helper PowerShell script and .bat file are used for copying files around from the PLC at runtime. Please see the scripts folder of this repository. 
These two files are called from the PLC using [NT_StartProcess](https://infosys.beckhoff.com/content/1033/tcplclib_tc2_utilities/35042443.html?id=1762541397744069181) at runtime.

3. The deployment properties of the PLC were modified. Two actions were added.
 Upon activation, the helper scripts folder is copied to the target, as well as all variant boot folders.

![image](https://user-images.githubusercontent.com/19829308/220225329-4bbfcf81-feb3-419b-9d7d-813e75732c4a.png)


# The PLC code sequence

4. On startup, the EtherCAT topology is scanned in. 
5. The Vendor, product, and revision number of each slave is stored in an array and then stored into a file for later reference.
6. The actual EtherCAT configuration is also read in.
7. The actual EtherCAT configuration is compared against the scanned-in topology. If the two match, a message is sent informing that the scanned topology and the actual configuration match. No further steps need to be taken if this is the case.
8. If the scanned-in topology doesn't match the actual configuration, it is then compared against all other variants to see if there is a match.
9. If a match is found, a message is sent indicating that the "X" variant matches and that you should consider loading it.
10. Knowing what variant now needs to be loaded, this information is passed to a PowerShell script to perform a swap for the appropriate boot folder. 
  - The PowerShell script performs the following:
    1. Deletes all files from the boot folder (C:\TwinCAT\3.1\Boot), except the TwinCAT logged events (loggedevents.db).
    2. Copies all the files from the selected variant boot folder at C:\TwinCAT\3.1\Target\Resource\Variants\X to the boot folder (C:\TwinCAT\3.1\Boot).
    3. Reboots the PC. A TwinCAT restart could be sufficient as an alternative. See [ADS PowerShell Module ->Set-AdsState](https://infosys.beckhoff.com/content/1033/tc3_ads_ps_tcxaemgmt/11224827403.html?id=7000601074958384797), use ADS port 10000.

This sample is created by [Beckhoff Automation LLC](https://www.beckhoff.com/en-us/) and is provided as-is under the Zero-Clause BSD license.

# How to get support

Should you have any questions regarding the provided sample code, please contact your local Beckhoff support team. Contact information can be found on the official Beckhoff website at https://www.beckhoff.com/en-us/support/.

# Further Information
[TwinCAT 3 | Machine update at file level](https://infosys.beckhoff.com/content/1033/tc3_grundlagen/10696055051.html?id=2628406925900354307)

[TwinCAT 3 | Variant Management](https://infosys.beckhoff.com/content/1033/variant_management/index.html?id=640168702518993771)

[TE1000 | TwinCAT 3 ADS PowerShell Module](https://infosys.beckhoff.com/content/1033/tc3_ads_ps_tcxaemgmt/index.html?id=532703962714578460)


## Requirements

The following components must be installed to run the sample code:

- [TE1000 TwinCAT 3 Engineering](https://www.beckhoff.com/TE1000) version 3.1.4024.0 or higher
- A copy of the PowerShell script and .bat from the scripts folder of this repo stored into C:\TwinCAT\3.1\Target\Resource.
