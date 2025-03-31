New Hire Account Creation Steps.
1.	RDP into a jump server as your admin account.- BEDPMGMT001
2.	Connect to the following share: \\BEDPAUTOSPRT001\LHI_Support\Scripts\Create-GlobalUser
3.	PLEASE Create a copy of the following file: “NewHire_Global_Template.csv” in the 
Directory: “\\BEDPAUTOSPRT001\LHI_Support\Logs\Archive”
4.	Name the template – yourname_GlobalNewhire.csv NO SPACED IN FILE NAME

5.	Launch PowerShell as admin and run the following command:

CD “\\BEDPAUTOSPRT001\LHI_Support\Scripts\Create-GlobalUser”
LS
.\Create-GlobalUser.ps1

6.	Priode the path of the file that you saved in step 3. SO copy the location as path and remove the quotes.

The account should be created and if anything failed you should see errors on the screen. 















