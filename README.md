# Kape4MDE

This script gives you a one stop shop for performing forensic acquisitions using KAPE via the MDE Live Response console

## Pre-defined Collections Examples 

    run kape.ps1 -parameters "-collection triage" 

The first collection is our triage script. If you are familiar with KAPE it runs the !SANS_Triage. This script provides us a vhdx file that contains the following artifacts: 

Anitvirus 
Cloud Storage Metadata 
Combined Logs (evtx, powershell, usb, etc.) 
EvidenceofExecution 
Filesystem 
LNKFilesand Jumplists 
Messaging Clients 
Recyclebin_InfoFiles 
Remote Access 
Registry 
Scheduled Tasks 
Thumbcache 
WBEM 
SRUM 
SUM 
WebBrowsers 
Windows Timeline 
WindowsIndexSearch 

    run kape.ps1 -parameters "-collection memory" 

The second collection will allow forensics to acquire all the memory related artifacts on a system. This command uses a Magnet RAM Capture module to acquire memory and dump it on the system. It will then collect hibernation files, page files, swap files and the crash dump directories. 

    run kape.ps1 -parameters "-collection split" 

This command is not a collection but gives the analyst the ability to split the evidence they have gathered into 2gb chunks. This allows the analyst to use the live response "getfile" command to grab each of the chunks. This command tends to be the biggest time sink and is prone to timeout. Running it in the background with the "&" character helps a bit. 

    run kape.ps1 -parameters "-collection all" 

This command takes the triage, memory, and split commands and runs them all in one. While this requires the least amount of manual effort on the analyst's part with MDE Live Response it is not ideal. The Live Response console tends to time out longer runtime commands and disconnect the session. Therefore, it is preferable and more reliable to run your collections in segments. 

    run kape.ps1 -parameters "-collection cleanup" 

This is the last predefined command, and it allows the analyst to clean up their acquisition. This command should be run when the analyst is done grabbing their evidence. 

 

## Custom Collections 

It was requested that a custom collection feature be implemented with the KAPE MDE deployment. Below you will find a few examples of custom collections. However, these collection types are only limited by the analysts' knowledge of KAPE targets.  

    - run kape.ps1 -parameters "-collection custom -artifacts RegistryHives" 
    - run kape.ps1 -parameters "-collection custom -artifacts KapeTriage" 
    - run kape.ps1 -parameters "-collection custom -artifacts ServerTriage" 
    - run kape.ps1 -parameters "-collection custom -artifacts Filesystem" 
    - run kape.ps1 -parameters "-collection custom -artifacts !BasicCollection" 

## Walkthrough 

1. To begin the analyst will need to navigate to the device page of the asset they would like to perform acquisition on. This is easily done by simply searching the asset in the search bar.
   
2. Once on the device page our next step is to initiate a Live Response connection.
   
3. You are now in Live Response session with the desired endpoint. You will need to push the required executables to the system by doing "putfile kape.zip". This may take a minute. 
   
4. Once the required files are pushed to the endpoint you are free to run whichever commands that you desire to acquire evidence. 
   
5. Once the evidence has been acquired the next steps depends on the size of the evidence. If the evidence is less than 2gb we can use a simple "getfile <evidence file name>" to grab the evidence (Kape writes the evidence to C:\kape\output). 

6. If the evidence is greater than 2gb we need to run the Split command to chunk the evidence into 2gb sections that we can then use the getfile command to grab. Note that the chunked files will be outputted to "C:\kape\Done".  
 

## Tips and Tricks 

- If you expect commands to take a longer amount of time it is a good idea to append an "&" to the end of the command. This forces the command to run in the background and will prevent a connection timeout. 
    - This should be used for the Split, all, and getfile commands. 
    - "fg <action GUID>" will bring the command to the foreground. 

## UPDATES!

### Parsed Triage Evidence

I have added a functionality that lets the evidence captured in the "triage" collection to also be parsed by EZParser tools and output to a zip file in the "C:\kape\output\parsed_evidence.zip". This is a result of me trying to make it as quick as possible to get our hands on evidence that is ready for analysis. It will still capture the SANS Triage collection and add it to a VHDX container! The following command should allow you to try out this functionality.

    - run kape.ps1 -parameters "-collection triage -parse true" 

Please note that I have not gotten a chance to try this in a MDE environment yet but it should work ith no issues. If you run into a problem feel free to let me know!