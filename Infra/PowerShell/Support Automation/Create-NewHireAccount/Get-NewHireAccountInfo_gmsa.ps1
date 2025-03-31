#Script Runs using the gMSA_UserInfo account and gets the new hire info from the SQL DB and Checks for an avalaible User Name.

# Function to get new hire info
function Get-NewHireInfo {
    param (
        [string]$Ticket_ParentID
    )

    try {

        # Establish a SQL connection
        $serverName = "BEDPSQLCTS001"
        $databaseName = "CherwellProd"
        $sqlConn = New-Object System.Data.SqlClient.SqlConnection
        $sqlConn.ConnectionString = "Server=$serverName;Database=$databaseName;trusted_connection=true;"


        # Create a SQL command for the stored procedure
        $sqlCmd = $sqlConn.CreateCommand()
        $sqlCmd.CommandType = [System.Data.CommandType]::StoredProcedure
        $sqlCmd.CommandText = "spGetHRformdata"
        $sqlCmd.Parameters.Add("@Incident", [System.Data.SqlDbType]::VarChar).Value = $Ticket_ParentID

        # Open the connection
        $sqlConn.Open()

        # Execute the stored procedure
        $sqlReader = $sqlCmd.ExecuteReader()

        # Create an empty hash table to store the new hire information
        $NewHireInfo = @{}

        # Process the results
        while ($sqlReader.Read()) {
            $NewHireInfo = @{
                "IncidentID" = $sqlReader["IncidentID"]
                "FirstName" = $sqlReader["FirstName"]
                "MiddleInitial" = $sqlReader["MiddleInitial"]
                "LastName" = $sqlReader["LastName"]
                "Title" = $sqlReader["Title"]
                "Department" = $sqlReader["Department"]
                "Manager" = $sqlReader["Manager"]
                "StartDate" = $sqlReader["StartDate"]
                "PersonalEmailAddress" = $sqlReader["PersonalEmailAddress"]
                "SeatNumber" = $sqlReader["SeatNumber"]
                "WorkEnvironment" = $sqlReader["WorkEnvironment"]
            }
        }

        # Close the reader
        $sqlReader.Close()
    }
    catch {
        Write-Host "Error accessing the database: $_"
    }
    finally {
        # Close the connection
        $sqlConn.Close()
    }

    try {
        # Establish a second SQL connection
        $serverName = "BEDSQLRPT002"
        $databaseName = "ReportingDM"
        $sqlConn = New-Object System.Data.SqlClient.SqlConnection
        $sqlConn.ConnectionString = "Server=$serverName;Database=$databaseName;trusted_connection=true;"

        # Execute the SQL query
        $query = @"
        SELECT logonname, firstName, lastname, Fullname
        FROM [ReportingDM].[dbo].[DimRCMOperator_Master] with(nolock)
"@
        # Create a command object
        $sqlCmd = $sqlConn.CreateCommand()
        $sqlCmd.CommandText = $query

        # Connect to SQL
        $sqlConn.Open()

        # Execute the query and store the results in a DataTable
        $dataTable = New-Object System.Data.DataTable
        $dataAdapter = New-Object System.Data.SqlClient.SqlDataAdapter $sqlCmd
        $dataAdapter.Fill($dataTable)
        $operatorData = $dataTable
    }
    catch {
        Write-Host "Error accessing the database: $_"
    }
    finally {
        # Close the connection
        $sqlConn.Close()
    }

    # Return the new hire information
    return [PSCustomObject]@{
        NewHireInfo = $NewHireInfo
        OperatorData = $operatorData
    }
}


function GenerateUsername {
    param (
        [string]$FirstName,
        [string]$LastName,
        [array]$Current_AllscriptsLogonName
    )

    # Generate the username
    $Username = ($FirstName[0] + $LastName).ToLower()

    # Check if the username exists in the array
    if ($Username -in $Current_AllscriptsLogonName) {
        Write-Host "$Username is already taken."

        $Alt_Username = ($FirstName.Substring(0, 3) + $LastName).ToLower()

        if ($Alt_Username -in $Current_AllscriptsLogonName) {
            Write-Host "$Alt_Username is already taken."

            # Check for the first 4 initials and last name
            $Alt_Username2 = ($FirstName.Substring(0, 4) + $LastName).ToLower()
            Write-Host "$Alt_Username2 is the available UserName"

            return $Alt_Username2
        } else {
            return $Alt_Username
        }
    } else {
        Write-Host "$Username is available."
        return $Username
    }
}

# Main script block
#Get the Ticket number from here:
$Ticket_ParentID = Get-Content -path "D:\Scripts\Create-NewHireAccount\incidentID.txt"
$info = Get-NewHireInfo($Ticket_ParentID)

$available_username = GenerateUsername -FirstName $info.NewHireInfo.FirstName -LastName $info.NewHireInfo.LastName -Current_AllscriptsLogonName $info.OperatorData.logonname
Write-Output "Available username: $available_username"

$NewHireInfo_export = @{
    Title = $info.NewHireInfo.Title
    Department = $info.NewHireInfo.Department
    FirstName = $info.NewHireInfo.FirstName
    LastName = $info.NewHireInfo.LastName
    Manager = $info.NewHireInfo.Manager
    WorkEnvironment = $info.NewHireInfo.WorkEnvironment
    PersonalEmailAddress = $info.NewHireInfo.PersonalEmailAddress
    SeatNumber = $info.NewHireInfo.SeatNumber
    MiddleInitial = $info.NewHireInfo.MiddleInitial
    IncidentID = $info.NewHireInfo.IncidentID
    StartDate = $info.NewHireInfo.StartDate
    AvailableUsername = $available_username
}

# Export the data to a CSV file
$csvPath = "D:\Scripts\Create-NewHireAccount\NewHireInfo.csv"
$NewHireInfo_export.GetEnumerator() | Export-Csv -Path $csvPath -NoTypeInformation
