# <div align="center">Active Directory Bulk User Creation</div>

This PowerShell script automates the creation of a specified number of user accounts in Active Directory. It generates random first and last names to create unique usernames and assigns a predefined password to each account. The script also creates a new Organizational Unit (OU) named _USERS to organize the new accounts.

## Features
- ***Bulk User Creation:*** Automatically creates a specified number of user accounts.
- ***Random Name Generation:*** Uses predefined lists of first and last names to generate unique usernames.
- ***Password Assignment:*** Assigns a secure password to each account.
- ***Organizational Unit Management:*** Creates a new OU _USERS for the new accounts.
- ***Error Handling:*** Includes error handling to report any issues during the user creation process.
- ***User Details:*** Sets various user attributes including GivenName, Surname, DisplayName, EmployeeID, and more.
- ***Password Policy:*** Configures passwords to never expire.

## Usage

***Clone the Repository:***

    git clone https://github.com/fadiabdelrahim/Active-Directory-Bulk-User-Creation.git

    cd Active-Directory-Bulk-User-Creation

  ---

***Edit Script Parameters:***

Modify the following parameters at the beginning of the script as needed:
- ***$PASSWORD_FOR_USERS:*** The password assigned to all new user accounts.
- ***$NUMBER_OF_ACCOUNTS_TO_CREATE:*** The number of user accounts to create.

  ---

***Run the Script:***

Open PowerShell with administrative privileges and run the script:

    .\AD-Create-Users.ps1

## Script Details

    # Define the password for new user accounts and the number of accounts to create
    $PASSWORD_FOR_USERS = "Password1"
    $NUMBER_OF_ACCOUNTS_TO_CREATE = 1000
    
    # Create a new Organizational Unit (OU) named _USERS and disable accidental deletion protection
    New-ADOrganizationalUnit -Name _USERS -ProtectedFromAccidentalDeletion $false
    
    # Function to generate a random first name from a predefined list
    Function generate-random-first-name() {
        $firstName = @('james', 'john', 'robert', 'michael', 'william', 'david', 'richard', 'joseph', 'charles', 'thomas',
                       'christopher', 'daniel', 'matthew', 'anthony', 'mark', 'donald', 'steven', 'paul', 'andrew', 'joshua',
                       'kevin', 'brian', 'george', 'edward', 'ronald', 'timothy', 'jason', 'jeffrey', 'ryan', 'jacob',
                       'gary', 'nicholas', 'eric', 'stephen', 'jonathan', 'larry', 'justin', 'scott', 'brandon', 'benjamin',
                       'samuel', 'frank', 'gregory', 'raymond', 'alexander', 'patrick', 'jack', 'dennis', 'jerry', 'tyler',
                       'aaron', 'henry', 'douglas', 'peter', 'adam', 'zachary', 'nathan', 'walter', 'harold', 'kyle',
                       'arthur', 'carl', 'lawrence', 'dylan', 'jordan', 'albert', 'joe', 'eugene', 'ralph', 'bruce',
                       'roy', 'bobby', 'rusell', 'phillip', 'vincent', 'gabriel', 'randy', 'howard', 'juan', 'louis')
        return $firstName[(Get-Random -Minimum 3 -Maximum $($firstName.Count - 1))]
    }
    
    # Function to generate a random last name from a predefined list
    Function generate-random-last-name() {
        $lastName = @('smith', 'johnson', 'williams', 'brown', 'jones', 'garcia', 'miller', 'davis', 'rodriguez', 'martinez',
                      'hernandez', 'lopez', 'gonzalez', 'wilson', 'anderson', 'thomas', 'taylor', 'moore', 'jackson', 'martin',
                      'lee', 'perez', 'thompson', 'white', 'harris', 'sanchez', 'clark', 'ramirez', 'lewis', 'robinson',
                      'walker', 'young', 'allen', 'king', 'wright', 'scott', 'torres', 'nguyen', 'hill', 'flores',
                      'green', 'adams', 'nelson', 'baker', 'hall', 'rivera', 'campbell', 'mitchell', 'carter', 'roberts',
                      'gomez', 'phillips', 'evans', 'turner', 'diaz', 'parker', 'cruz', 'edwards', 'collins', 'reyes',
                      'stewart', 'morris', 'morales', 'murphy', 'cook', 'rogers', 'gutierrez', 'orbitz', 'morgan', 'cooper',
                      'peterson', 'bailey', 'reed', 'kelly', 'howard', 'ramos', 'kim', 'cox', 'ward', 'richardson')
        return $lastName[(Get-Random -Minimum 3 -Maximum $($lastName.Count - 1))]
    }
    
    # Initialize a counter for the number of accounts created
    $count = 1
    
    # Loop to create the specified number of user accounts
    while ($count -lt $NUMBER_OF_ACCOUNTS_TO_CREATE) {
        # Generate a random first and last name
        $firstName = generate-random-first-name
        $lastName = generate-random-last-name
        # Construct the username from the first and last names
        $username = $firstName + '.' + $lastName
        # Convert the password to a secure string
        $password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force

        # Print a message indicating the creation of a new user
        Write-Host "Creating User: $($username)" -BackgroundColor Black -ForegroundColor DarkYellow

        try {
            # Attempt to create a new Active Directory user with the generated details
            New-ADUser -AccountPassword $password `
                       -GivenName $firstName `
                       -Surname $lastName `
                       -DisplayName $username `
                       -Name $username `
                       -EmployeeID $username `
                       -PasswordNeverExpires $true `
                       -Path "ou=_USERS,$(([ADSI]`"").distinguishedName)" `
                       -Enabled $true
            # Increment the counter upon successful creation
            $count++
        } catch {
            # Print an error message if user creation fails
            Write-Host "Failed to create user: $($username) Error: $($_.Exception.Message)" -BackgroundColor Black -ForegroundColor Red
        }
    }

---

***Variable Definitions:*** Variables $PASSWORD_FOR_USERS and $NUMBER_OF_ACCOUNTS_TO_CREATE are defined at the beginning to make the script easily configurable.

***Organizational Unit Creation:*** The script creates a new Organizational Unit (OU) named _USERS with accidental deletion protection disabled.

***Random Name Generation Functions:*** Two functions, generate-random-first-name and generate-random-last-name, generate random names from predefined lists.

***User Creation Loop:*** The loop runs until the specified number of accounts is created, using random names to create unique usernames and accounts.

***Error Handling:*** The script includes error handling to catch and report any issues encountered during user creation.

***Output:*** The script outputs messages to indicate the progress of user creation and any errors encountered.

