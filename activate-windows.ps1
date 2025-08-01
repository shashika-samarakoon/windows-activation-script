# Set strict error handling
$ErrorActionPreference = "Stop"

# Password Authentication
$correctPassword = "Test@123"
$password = Read-Host -Prompt "Enter script password" -AsSecureString
$plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
)

if ($plainPassword -ne $correctPassword) {
    Write-Host "Incorrect password. Exiting..." -ForegroundColor Red
    exit
}

Write-Host "Password verified." -ForegroundColor Green

# OS Selection
Write-Host "`nSelect your OS version:"
Write-Host "1. Windows Server 2022"
Write-Host "2. Windows Server 2019"
$osChoice = Read-Host "Enter choice [1 or 2]"

switch ($osChoice) {
    '1' {
        $productKey = "WX4NM-KYWYW-QJJR4-XV3QB-6VM33"  # 2022 Datacenter
    }
    '2' {
        $productKey = "N69G4-B89J2-4G8F4-WWYCC-J464C"  # 2019 Datacenter
    }
    Default {
        Write-Host "Invalid choice. Exiting..." -ForegroundColor Red
        exit
    }
}

# Activation commands
Write-Host "`n⚙️  Installing product key..."
slmgr /ipk $productKey

Write-Host "Setting KMS server..."
slmgr /skms kms8.msguides.com

Write-Host "Attempting activation..."
slmgr /ato

Write-Host "`n✅ Windows activation process triggered."
