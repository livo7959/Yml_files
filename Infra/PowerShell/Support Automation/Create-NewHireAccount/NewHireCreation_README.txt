Overview:
Automats the new hire account creation, with leveraging SQL Cherwell(TS) Dbs info and the Allscripts ReportingPM DBs for validating available usernames.
This is a building block for faster new hire onboarding and making sure everyone starts with the Sames best of pre-approved access based on templates. (UPDAET ALL THE TEMPLATES AS NEEDED)

The scripts alos uses an XML file that has all the info for templates destinations in AD based on the Departments and based on two "flavors" Basic user and Mangment, some of the department
have a few templates, as more needed. BUT clean up the ones that are no longer being used.

HOW THE SCRIPTS WORKS:

1. The script will work with the logged-on Admins Creds and by providing the new hires ticket number, and executes a Scheduled task
to run the gMSA account (limited access to the DBs: CherwellProd, ReportingDM ) to retrieve the file and use the regular admin creds to create the account and provision the other part.

ONCE its successfully created, the script will check by searching AD for the following username and "THE NEW ACCOUNT CREATED" and if so, move the file to an archive folder location

PATH: D:\Logs\NewHire_Archives this is the original file with the user's info that gets exported form the ticketing system and the generate new hire USERNAME FUNCTION, and also logs
what worked and what might have failed.


PLEASE RUN THE SCRIPT IN A PS WINDOW TO CHECK FOR LOGS AND FOR BUGS. This is important so we can update the scripts as necessary.

HOW TO USE THE SCRIPT:

1. Run PowerShell 7 as admin, and
CD "D:\Scripts\Create-NewHireAccount"
type in  .\Create-NewHire.ps1

2. Enter the ticket Number and wait about 1 min for the AD account to be provisoned.

3. Document any errors if printed on the console.

FUTURE ADDITION:
//Working on trying to get Allscipts account provisioned as well.

//Can not do LF or Connect -> if someone wants to take a stab feel free.