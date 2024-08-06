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
