# activate-windows.ps1

# === CONFIGURE YOUR PASSWORD HERE ===
$plainPassword = "user@1234"
$expectedHash = [System.BitConverter]::ToString(
    (New-Object Security.Cryptography.SHA256Managed).ComputeHash(
        [System.Text.Encoding]::UTF8.GetBytes($plainPassword))
).Replace("-", "").ToLower()

# === PASSWORD PROMPT ===
$securePwd = Read-Host "Enter password to proceed" -AsSecureString
$pwdBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd)
$enteredPwd = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($pwdBSTR)

$enteredHash = [System.BitConverter]::ToString(
    (New-Object Security.Cryptography.SHA256Managed).ComputeHash(
        [System.Text.Encoding]::UTF8.GetBytes($enteredPwd))
).Replace("-", "").ToLower()

if ($enteredHash -ne $expectedHash) {
    Write-Error "Authentication failed. Access denied."
    exit
}

# === OS SELECTION ===
Write-Host "`nSelect the Windows Server version to activate:"
Write-Host "1. Windows Server 2022"
Write-Host "2. Windows Server 2019"
$choice = Read-Host "Enter your choice (1 or 2)"

switch ($choice) {
    "1" {
        $productKey = "WX4NM-KYWYW-QJJR4-XV3QB-6VM33"  # Server 2022 Standard
    }
    "2" {
        $productKey = "WMDGN-G9PQG-XVVXX-R3X43-63DFG"  # Server 2019 Standard
    }
    default {
        Write-Error "Invalid selection."
        exit
    }
}

# === ACTIVATION ===
try {
    slmgr /ipk $productKey
    slmgr /skms kms8.msguides.com
    slmgr /ato
    Write-Host "`Activation attempted for Windows Server $choice"
} catch {
    Write-Error "Activation failed: $_"
}
