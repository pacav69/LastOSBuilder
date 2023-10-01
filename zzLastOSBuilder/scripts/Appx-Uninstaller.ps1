# A basic script for uninstalling app packages in Windows 10/11, including those pre-installed with Windows
#
# Note: If you get an error about the script not being allowed to run, the below command will change the execution polciy temporarily for one session only:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
#
# To execute the script, open a Powershell window to the directory with the script and run the following command using your scripts file name (and don't forget the .\ )
# .\WhateverScriptName.ps1
# -------------------------------------------------------------------------------------------
# Script by ThioJoe - https://github.com/ThioJoe
# Appx-Uninstaller.ps1

# Display AppX packages that are installed
Get-AppxPackage | Select Name, PackageFullName | Out-Host

# Pause the script and display instructions
Write-Host "Please create a text file called list.txt, then copy the names of the packages you want to uninstall into it, one per line."
Write-Host "NOTE: Some of the packages listed above are important. Do not uninstall any packages if you're unsure about their function!"
Write-Host ""
Write-Host "Then press any key to continue ..."
Read-Host

# Check if list.txt exists
if (-not (Test-Path -Path 'list.txt')) {
    Write-Host "Error: list.txt not found. Please create it in the same directory as this script, and add the packages you want to uninstall."
    return
}

# Read from the file
$lines = Get-Content -Path 'list.txt'

# Create an array to hold unsuccessful attempts
$notFound = @()

# Process each line
foreach ($line in $lines) {
    # Trim any leading or trailing white space
    $line = $line.Trim()

    # Ignore empty lines
    if (-not [string]::IsNullOrWhiteSpace($line)) {
        # Get the package, if it exists
        $package = Get-AppxPackage | Where-Object { $_.Name -eq $line -or $_.PackageFullName -eq $line }

		# If package was found, proceed to remove it, otherwise add it to list of apps not found
        if ($package) {
			# Try to remove app, and if error occurs display it, but will keep going to the next ones
            try {
                $package | Remove-AppxPackage -ErrorAction Stop
            }
            catch {
                Write-Host "Error while trying to uninstall $($line): $_"
                $notFound += $line
            }
        }
        else {
            $notFound += $line
        }
    }
}

# If there were unsuccessful attempts, print a warning
if ($notFound) {
    Write-Host "[!!!] WARNING: The following packages were not found and could not be uninstalled:"
    Write-Host ""

    # Print each package name that was not found
    foreach ($package in $notFound) {
        Write-Host "`t$package"
    }
    Write-Host ""
    Write-Host "Please re-check the names to ensure they exactly match a package's 'Name' or 'PackageFullName'."
    Write-Host "(Also check if the Full Name was truncated with '...', and if so try the shorter 'Name' string.)"
    Write-Host ""
}

# SIG # Begin signature block
# MIIplgYJKoZIhvcNAQcCoIIphzCCKYMCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAXVqh6uZAIgWiA
# 1rwOgNqeLM5jyuNikyay5kjY+dqwvaCCDoMwggawMIIEmKADAgECAhAIrUCyYNKc
# TJ9ezam9k67ZMA0GCSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNV
# BAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0yMTA0MjkwMDAwMDBaFw0z
# NjA0MjgyMzU5NTlaMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# ggIKAoICAQDVtC9C0CiteLdd1TlZG7GIQvUzjOs9gZdwxbvEhSYwn6SOaNhc9es0
# JAfhS0/TeEP0F9ce2vnS1WcaUk8OoVf8iJnBkcyBAz5NcCRks43iCH00fUyAVxJr
# Q5qZ8sU7H/Lvy0daE6ZMswEgJfMQ04uy+wjwiuCdCcBlp/qYgEk1hz1RGeiQIXhF
# LqGfLOEYwhrMxe6TSXBCMo/7xuoc82VokaJNTIIRSFJo3hC9FFdd6BgTZcV/sk+F
# LEikVoQ11vkunKoAFdE3/hoGlMJ8yOobMubKwvSnowMOdKWvObarYBLj6Na59zHh
# 3K3kGKDYwSNHR7OhD26jq22YBoMbt2pnLdK9RBqSEIGPsDsJ18ebMlrC/2pgVItJ
# wZPt4bRc4G/rJvmM1bL5OBDm6s6R9b7T+2+TYTRcvJNFKIM2KmYoX7BzzosmJQay
# g9Rc9hUZTO1i4F4z8ujo7AqnsAMrkbI2eb73rQgedaZlzLvjSFDzd5Ea/ttQokbI
# YViY9XwCFjyDKK05huzUtw1T0PhH5nUwjewwk3YUpltLXXRhTT8SkXbev1jLchAp
# QfDVxW0mdmgRQRNYmtwmKwH0iU1Z23jPgUo+QEdfyYFQc4UQIyFZYIpkVMHMIRro
# OBl8ZhzNeDhFMJlP/2NPTLuqDQhTQXxYPUez+rbsjDIJAsxsPAxWEQIDAQABo4IB
# WTCCAVUwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUaDfg67Y7+F8Rhvv+
# YXsIiGX0TkIwHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0P
# AQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcGCCsGAQUFBwEBBGswaTAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAC
# hjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9v
# dEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAcBgNVHSAEFTATMAcGBWeBDAED
# MAgGBmeBDAEEATANBgkqhkiG9w0BAQwFAAOCAgEAOiNEPY0Idu6PvDqZ01bgAhql
# +Eg08yy25nRm95RysQDKr2wwJxMSnpBEn0v9nqN8JtU3vDpdSG2V1T9J9Ce7FoFF
# UP2cvbaF4HZ+N3HLIvdaqpDP9ZNq4+sg0dVQeYiaiorBtr2hSBh+3NiAGhEZGM1h
# mYFW9snjdufE5BtfQ/g+lP92OT2e1JnPSt0o618moZVYSNUa/tcnP/2Q0XaG3Ryw
# YFzzDaju4ImhvTnhOE7abrs2nfvlIVNaw8rpavGiPttDuDPITzgUkpn13c5Ubdld
# AhQfQDN8A+KVssIhdXNSy0bYxDQcoqVLjc1vdjcshT8azibpGL6QB7BDf5WIIIJw
# 8MzK7/0pNVwfiThV9zeKiwmhywvpMRr/LhlcOXHhvpynCgbWJme3kuZOX956rEnP
# LqR0kq3bPKSchh/jwVYbKyP/j7XqiHtwa+aguv06P0WmxOgWkVKLQcBIhEuWTatE
# QOON8BUozu3xGFYHKi8QxAwIZDwzj64ojDzLj4gLDb879M4ee47vtevLt/B3E+bn
# KD+sEq6lLyJsQfmCXBVmzGwOysWGw/YmMwwHS6DTBwJqakAwSEs0qFEgu60bhQji
# WQ1tygVQK+pKHJ6l/aCnHwZ05/LWUpD9r4VIIflXO7ScA+2GRfS0YW6/aOImYIbq
# yK+p/pQd52MbOoZWeE4wggfLMIIFs6ADAgECAhAIDbJ1eLBvhEUmSTXbMO0DMA0G
# CSqGSIb3DQEBCwUAMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwg
# SW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcg
# UlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwHhcNMjMwMzA0MDAwMDAwWhcNMjUwMTA0
# MjM1OTU5WjCB0zETMBEGCysGAQQBgjc8AgEDEwJVUzEYMBYGCysGAQQBgjc8AgEC
# EwdXeW9taW5nMR0wGwYDVQQPDBRQcml2YXRlIE9yZ2FuaXphdGlvbjEXMBUGA1UE
# BRMOMjAyMS0wMDEwNTUxMTkxCzAJBgNVBAYTAlVTMRAwDgYDVQQIEwdXeW9taW5n
# MREwDwYDVQQHEwhTaGVyaWRhbjEbMBkGA1UEChMSVGhpbyBTb2Z0d2FyZSwgTExD
# MRswGQYDVQQDExJUaGlvIFNvZnR3YXJlLCBMTEMwggIiMA0GCSqGSIb3DQEBAQUA
# A4ICDwAwggIKAoICAQCyUph17S2KERvqfBBVI2wuQIVe+uZffJjzfWX1H9G0TnfS
# QWLTyXGxb/nT6nnwN/7ibHJldTwsSTaPOTkvaSnZuz0+AZPRXIiT/DuV3loOSqPX
# MYv1uQKDvLFzc+WOGkt2+cMXTFkP4joCPvkKb5+M2fapeNVxej7C5h4Ef3ABlg3o
# otc2xdZjGvPnxA9dnbdlNzJsRnjHHKPYwknl3QVra4PfP74D8K7dCxTzZUQpYYGy
# kZ05VHSuAG2HaPzr5o6CBnDv1ITvHX92JraAMcBd/gfcJsWoPH05mFgQfKDP3wru
# TQ9Ql2y67BFRXJR3RogMmu1FLsKzyP8yuZfcr7IWIiFgwYUzFs5k6FFy9kt1Cvs+
# zyFtUPUeWtv01hZY+MC2/Qdy/CqGPkyPs4woh5ajEx1GcY11laRFUADWtgXJY0gG
# gl5suB8V4iaGt9iA0frfLyWq/F0h9U4tKnHucgf3DT58hM29el/3VqJx7ERgAc78
# XRBgXDNxSsQpFsr/MvGGax27ayTvwMQm25UUbNTyFo0Nb0wxYXPYlA38+DwdXDYK
# q5BkNqqot44C/xZImP/F8ecnyIY9M2nhMtX49pC6zGJw6wtdhG5bKJFDRCwpy1wi
# vCVifhV2M3RuydUW1StYunzbhwQAAI6bg2Gz6vmLd6QZ69Zt6YxSDhrNVce41QID
# AQABo4ICAjCCAf4wHwYDVR0jBBgwFoAUaDfg67Y7+F8Rhvv+YXsIiGX0TkIwHQYD
# VR0OBBYEFHSwnMhQo43ayv0NcY2KnesS3hJWMA4GA1UdDwEB/wQEAwIHgDATBgNV
# HSUEDDAKBggrBgEFBQcDAzCBtQYDVR0fBIGtMIGqMFOgUaBPhk1odHRwOi8vY3Js
# My5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmluZ1JTQTQw
# OTZTSEEzODQyMDIxQ0ExLmNybDBToFGgT4ZNaHR0cDovL2NybDQuZGlnaWNlcnQu
# Y29tL0RpZ2lDZXJ0VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0MjAy
# MUNBMS5jcmwwPQYDVR0gBDYwNDAyBgVngQwBAzApMCcGCCsGAQUFBwIBFhtodHRw
# Oi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwgZQGCCsGAQUFBwEBBIGHMIGEMCQGCCsG
# AQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wXAYIKwYBBQUHMAKGUGh0
# dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNENvZGVT
# aWduaW5nUlNBNDA5NlNIQTM4NDIwMjFDQTEuY3J0MAkGA1UdEwQCMAAwDQYJKoZI
# hvcNAQELBQADggIBADDtgBDkKblvpa1Q24nmKq/hI8tRYPV7E2Umhk2BlSoBC+6M
# bNCDDltR/3OqFo6x9MxEuZnO4rC2eUMR4M/Xkj6E1GEKmm9ZOBTvgj6VDM5qv87G
# 8S1fq8yNr3srRLCtt7XXeVnRacSXAzD9NKr5QjZqOnD7uqWchvDMhVyT1WSvUACO
# 8K/Hr3kXtPIpLN3T6vxe9TwAwDxSk3/eeAHIQJN2EdcbhDEvDcOpkEse7bGNdZGG
# unlWOfBwCYuRarznUxz7kr8+MZIf3TixpOBHKjcGUeOAvPysqPBv+I6my7yrYirJ
# OlxqEOoY8psBU7z4L6vctr9/5DjltG4wQLjVfFpVHpizsk/EYr/jdHFmcqD6/edY
# PhMPaT8ItORC/EaXyBmOcKapegl9ay03kKztykuV/jsTRMFfGpGq/fTVY6R3bxMw
# HO3odlQnEvtGVXox8A4kp/6HZy4mh0BXJLjj+JZrEukizOnMa5Yr4H50GutgGfCL
# 7JqEBzv5pr+1Lyhkuwc2zBtcP9zrDdFqvi2rIQqU2OksE2wSuy2YnsiR1ekSxVNl
# JqrJXzEfZUprneVKOypREFFwek6cWbgXlJLr6XvBjq/hANBdhueMOJHkJoosL3SZ
# 7hAAPeUnGF5LQVK5dSHYVvcOT90g/eJ0NCX7wSDKjJ6A5weLkEZD+l/ef4VtMYIa
# aTCCGmUCAQEwfTBpMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIElu
# Yy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQgQ29kZSBTaWduaW5nIFJT
# QTQwOTYgU0hBMzg0IDIwMjEgQ0ExAhAIDbJ1eLBvhEUmSTXbMO0DMA0GCWCGSAFl
# AwQCAQUAoHwwEAYKKwYBBAGCNwIBDDECMAAwGQYJKoZIhvcNAQkDMQwGCisGAQQB
# gjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkE
# MSIEIHhjsoWf3cTdRguwPchvVodVJf0tYurtasAPXMVek5xVMA0GCSqGSIb3DQEB
# AQUABIICAHROf1OtruPigijarhZeX4GBnsOvVoGv4526PdabJyvwLQL+r/Q7V6zb
# +yt4sAEYJqsjKUKD+uzXSwD/WnWcnVPO2FRlj2WDPHjnjkAZqiorM50J2pJO8FO1
# D3RCpLxs4mRNcQ0EOVlfx0EmAeyzDtWsSeoYs9KvjgGoHN1J3RLl9swy/WN8eXFa
# NpUfvzxcE5XDVLgfO7k45Oi6Zthd3VXwGVj87tfinuEQDQ9nNsn9NDom5tPHyEiv
# 9dwmkRgPNL/XQHrSa67G7w42NI+pjJtjK3J7XlRzvFHVgz/a+7yCfNAdLu/FKxuw
# vCqtuHQxDzQZyvGTLMgszgQl2neelFHHGsV3n3jAlhkcZeSjhERAZhGYPDWjfPn3
# Ffg4Tt+qHzp+h+cs0/I77HIp4b7d1aSd0WDxOIQX8liDNXTyy37vRKs+s3GeK+BB
# fFGo5Oz2enZ9O6yux3kt9WyyQyOKwWOQYkksxN3d8g2ya57ob3bUMDzIAfslMRcx
# pYznlLc2eFwMyt8FmWHsIrJQegNQ2zKvUeJbBI6mBeGOk50zoY/n8nnCJUuqBCoq
# PSQz8bkpapuBgDSzGIcwE93RUo28d0gM6kLN1c2vaV413b2VSf22mUCg2A2g6/Xw
# br4mhlPKCdHOeH3LlpEbqhSXp/IN2drUN+LCM+ZaFnHcHXPmG2+ToYIXPzCCFzsG
# CisGAQQBgjcDAwExghcrMIIXJwYJKoZIhvcNAQcCoIIXGDCCFxQCAQMxDzANBglg
# hkgBZQMEAgEFADB3BgsqhkiG9w0BCRABBKBoBGYwZAIBAQYJYIZIAYb9bAcBMDEw
# DQYJYIZIAWUDBAIBBQAEIPBIC5RnF/H42T4afZ1azS6yhezml5OH3PO5LqqblETF
# AhBAFfEFt0qHv02fcruVqZsfGA8yMDIzMDgyNTIwMDEzMFqgghMJMIIGwjCCBKqg
# AwIBAgIQBUSv85SdCDmmv9s/X+VhFjANBgkqhkiG9w0BAQsFADBjMQswCQYDVQQG
# EwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0
# IFRydXN0ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENBMB4XDTIz
# MDcxNDAwMDAwMFoXDTM0MTAxMzIzNTk1OVowSDELMAkGA1UEBhMCVVMxFzAVBgNV
# BAoTDkRpZ2lDZXJ0LCBJbmMuMSAwHgYDVQQDExdEaWdpQ2VydCBUaW1lc3RhbXAg
# MjAyMzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAKNTRYcdg45brD5U
# syPgz5/X5dLnXaEOCdwvSKOXejsqnGfcYhVYwamTEafNqrJq3RApih5iY2nTWJw1
# cb86l+uUUI8cIOrHmjsvlmbjaedp/lvD1isgHMGXlLSlUIHyz8sHpjBoyoNC2vx/
# CSSUpIIa2mq62DvKXd4ZGIX7ReoNYWyd/nFexAaaPPDFLnkPG2ZS48jWPl/aQ9OE
# 9dDH9kgtXkV1lnX+3RChG4PBuOZSlbVH13gpOWvgeFmX40QrStWVzu8IF+qCZE3/
# I+PKhu60pCFkcOvV5aDaY7Mu6QXuqvYk9R28mxyyt1/f8O52fTGZZUdVnUokL6wr
# l76f5P17cz4y7lI0+9S769SgLDSb495uZBkHNwGRDxy1Uc2qTGaDiGhiu7xBG3gZ
# beTZD+BYQfvYsSzhUa+0rRUGFOpiCBPTaR58ZE2dD9/O0V6MqqtQFcmzyrzXxDto
# RKOlO0L9c33u3Qr/eTQQfqZcClhMAD6FaXXHg2TWdc2PEnZWpST618RrIbroHzSY
# LzrqawGw9/sqhux7UjipmAmhcbJsca8+uG+W1eEQE/5hRwqM/vC2x9XH3mwk8L9C
# gsqgcT2ckpMEtGlwJw1Pt7U20clfCKRwo+wK8REuZODLIivK8SgTIUlRfgZm0zu+
# +uuRONhRB8qUt+JQofM604qDy0B7AgMBAAGjggGLMIIBhzAOBgNVHQ8BAf8EBAMC
# B4AwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAgBgNVHSAE
# GTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwHwYDVR0jBBgwFoAUuhbZbU2FL3Mp
# dpovdYxqII+eyG8wHQYDVR0OBBYEFKW27xPn783QZKHVVqllMaPe1eNJMFoGA1Ud
# HwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRy
# dXN0ZWRHNFJTQTQwOTZTSEEyNTZUaW1lU3RhbXBpbmdDQS5jcmwwgZAGCCsGAQUF
# BwEBBIGDMIGAMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20w
# WAYIKwYBBQUHMAKGTGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2Vy
# dFRydXN0ZWRHNFJTQTQwOTZTSEEyNTZUaW1lU3RhbXBpbmdDQS5jcnQwDQYJKoZI
# hvcNAQELBQADggIBAIEa1t6gqbWYF7xwjU+KPGic2CX/yyzkzepdIpLsjCICqbjP
# gKjZ5+PF7SaCinEvGN1Ott5s1+FgnCvt7T1IjrhrunxdvcJhN2hJd6PrkKoS1yeF
# 844ektrCQDifXcigLiV4JZ0qBXqEKZi2V3mP2yZWK7Dzp703DNiYdk9WuVLCtp04
# qYHnbUFcjGnRuSvExnvPnPp44pMadqJpddNQ5EQSviANnqlE0PjlSXcIWiHFtM+Y
# lRpUurm8wWkZus8W8oM3NG6wQSbd3lqXTzON1I13fXVFoaVYJmoDRd7ZULVQjK9W
# vUzF4UbFKNOt50MAcN7MmJ4ZiQPq1JE3701S88lgIcRWR+3aEUuMMsOI5ljitts+
# +V+wQtaP4xeR0arAVeOGv6wnLEHQmjNKqDbUuXKWfpd5OEhfysLcPTLfddY2Z1qJ
# +Panx+VPNTwAvb6cKmx5AdzaROY63jg7B145WPR8czFVoIARyxQMfq68/qTreWWq
# aNYiyjvrmoI1VygWy2nyMpqy0tg6uLFGhmu6F/3Ed2wVbK6rr3M66ElGt9V/zLY4
# wNjsHPW2obhDLN9OTH0eaHDAdwrUAuBcYLso/zjlUlrWrBciI0707NMX+1Br/wd3
# H3GXREHJuEbTbDJ8WC9nR2XlG3O2mflrLAZG70Ee8PBf4NvZrZCARK+AEEGKMIIG
# rjCCBJagAwIBAgIQBzY3tyRUfNhHrP0oZipeWzANBgkqhkiG9w0BAQsFADBiMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQw
# HhcNMjIwMzIzMDAwMDAwWhcNMzcwMzIyMjM1OTU5WjBjMQswCQYDVQQGEwJVUzEX
# MBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0IFRydXN0
# ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENBMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAxoY1BkmzwT1ySVFVxyUDxPKRN6mXUaHW0oPR
# nkyibaCwzIP5WvYRoUQVQl+kiPNo+n3znIkLf50fng8zH1ATCyZzlm34V6gCff1D
# tITaEfFzsbPuK4CEiiIY3+vaPcQXf6sZKz5C3GeO6lE98NZW1OcoLevTsbV15x8G
# ZY2UKdPZ7Gnf2ZCHRgB720RBidx8ald68Dd5n12sy+iEZLRS8nZH92GDGd1ftFQL
# IWhuNyG7QKxfst5Kfc71ORJn7w6lY2zkpsUdzTYNXNXmG6jBZHRAp8ByxbpOH7G1
# WE15/tePc5OsLDnipUjW8LAxE6lXKZYnLvWHpo9OdhVVJnCYJn+gGkcgQ+NDY4B7
# dW4nJZCYOjgRs/b2nuY7W+yB3iIU2YIqx5K/oN7jPqJz+ucfWmyU8lKVEStYdEAo
# q3NDzt9KoRxrOMUp88qqlnNCaJ+2RrOdOqPVA+C/8KI8ykLcGEh/FDTP0kyr75s9
# /g64ZCr6dSgkQe1CvwWcZklSUPRR8zZJTYsg0ixXNXkrqPNFYLwjjVj33GHek/45
# wPmyMKVM1+mYSlg+0wOI/rOP015LdhJRk8mMDDtbiiKowSYI+RQQEgN9XyO7ZONj
# 4KbhPvbCdLI/Hgl27KtdRnXiYKNYCQEoAA6EVO7O6V3IXjASvUaetdN2udIOa5kM
# 0jO0zbECAwEAAaOCAV0wggFZMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYE
# FLoW2W1NhS9zKXaaL3WMaiCPnshvMB8GA1UdIwQYMBaAFOzX44LScV1kTN8uZz/n
# upiuHA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDB3Bggr
# BgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNv
# bTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2Ny
# bDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcmwwIAYDVR0g
# BBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4ICAQB9
# WY7Ak7ZvmKlEIgF+ZtbYIULhsBguEE0TzzBTzr8Y+8dQXeJLKftwig2qKWn8acHP
# HQfpPmDI2AvlXFvXbYf6hCAlNDFnzbYSlm/EUExiHQwIgqgWvalWzxVzjQEiJc6V
# aT9Hd/tydBTX/6tPiix6q4XNQ1/tYLaqT5Fmniye4Iqs5f2MvGQmh2ySvZ180HAK
# fO+ovHVPulr3qRCyXen/KFSJ8NWKcXZl2szwcqMj+sAngkSumScbqyQeJsG33irr
# 9p6xeZmBo1aGqwpFyd/EjaDnmPv7pp1yr8THwcFqcdnGE4AJxLafzYeHJLtPo0m5
# d2aR8XKc6UsCUqc3fpNTrDsdCEkPlM05et3/JWOZJyw9P2un8WbDQc1PtkCbISFA
# 0LcTJM3cHXg65J6t5TRxktcma+Q4c6umAU+9Pzt4rUyt+8SVe+0KXzM5h0F4ejjp
# nOHdI/0dKNPH+ejxmF/7K9h+8kaddSweJywm228Vex4Ziza4k9Tm8heZWcpw8De/
# mADfIBZPJ/tgZxahZrrdVcA6KYawmKAr7ZVBtzrVFZgxtGIJDwq9gdkT/r+k0fNX
# 2bwE+oLeMt8EifAAzV3C+dAjfwAL5HYCJtnwZXZCpimHCUcr5n8apIUP/JiW9lVU
# Kx+A+sDyDivl1vupL0QVSucTDh3bNzgaoSv27dZ8/DCCBY0wggR1oAMCAQICEA6b
# GI750C3n79tQ4ghAGFowDQYJKoZIhvcNAQEMBQAwZTELMAkGA1UEBhMCVVMxFTAT
# BgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEk
# MCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4XDTIyMDgwMTAw
# MDAwMFoXDTMxMTEwOTIzNTk1OVowYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERp
# Z2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMY
# RGlnaUNlcnQgVHJ1c3RlZCBSb290IEc0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8A
# MIICCgKCAgEAv+aQc2jeu+RdSjwwIjBpM+zCpyUuySE98orYWcLhKac9WKt2ms2u
# exuEDcQwH/MbpDgW61bGl20dq7J58soR0uRf1gU8Ug9SH8aeFaV+vp+pVxZZVXKv
# aJNwwrK6dZlqczKU0RBEEC7fgvMHhOZ0O21x4i0MG+4g1ckgHWMpLc7sXk7Ik/gh
# YZs06wXGXuxbGrzryc/NrDRAX7F6Zu53yEioZldXn1RYjgwrt0+nMNlW7sp7XeOt
# yU9e5TXnMcvak17cjo+A2raRmECQecN4x7axxLVqGDgDEI3Y1DekLgV9iPWCPhCR
# cKtVgkEy19sEcypukQF8IUzUvK4bA3VdeGbZOjFEmjNAvwjXWkmkwuapoGfdpCe8
# oU85tRFYF/ckXEaPZPfBaYh2mHY9WV1CdoeJl2l6SPDgohIbZpp0yt5LHucOY67m
# 1O+SkjqePdwA5EUlibaaRBkrfsCUtNJhbesz2cXfSwQAzH0clcOP9yGyshG3u3/y
# 1YxwLEFgqrFjGESVGnZifvaAsPvoZKYz0YkH4b235kOkGLimdwHhD5QMIR2yVCkl
# iWzlDlJRR3S+Jqy2QXXeeqxfjT/JvNNBERJb5RBQ6zHFynIWIgnffEx1P2PsIV/E
# IFFrb7GrhotPwtZFX50g/KEexcCPorF+CiaZ9eRpL5gdLfXZqbId5RsCAwEAAaOC
# ATowggE2MA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFOzX44LScV1kTN8uZz/n
# upiuHA9PMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMA4GA1UdDwEB
# /wQEAwIBhjB5BggrBgEFBQcBAQRtMGswJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3Nw
# LmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3aHR0cDovL2NhY2VydHMuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNydDBFBgNVHR8EPjA8MDqg
# OKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
# b290Q0EuY3JsMBEGA1UdIAQKMAgwBgYEVR0gADANBgkqhkiG9w0BAQwFAAOCAQEA
# cKC/Q1xV5zhfoKN0Gz22Ftf3v1cHvZqsoYcs7IVeqRq7IviHGmlUIu2kiHdtvRoU
# 9BNKei8ttzjv9P+Aufih9/Jy3iS8UgPITtAq3votVs/59PesMHqai7Je1M/RQ0Sb
# QyHrlnKhSLSZy51PpwYDE3cnRNTnf+hZqPC/Lwum6fI0POz3A8eHqNJMQBk1Rmpp
# VLC4oVaO7KTVPeix3P0c2PR3WlxUjG/voVA9/HYJaISfb8rbII01YBwCA8sgsKxY
# oA5AY8WYIsGyWfVVa88nq2x2zm8jLfR+cWojayL/ErhULSd+2DrZ8LaHlv1b0Vys
# GMNNn3O3AamfV6peKOK5lDGCA3YwggNyAgEBMHcwYzELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVk
# IEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBDQQIQBUSv85SdCDmmv9s/
# X+VhFjANBglghkgBZQMEAgEFAKCB0TAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQ
# AQQwHAYJKoZIhvcNAQkFMQ8XDTIzMDgyNTIwMDEzMFowKwYLKoZIhvcNAQkQAgwx
# HDAaMBgwFgQUZvArMsLCyQ+CXc6qisnGTxmcz0AwLwYJKoZIhvcNAQkEMSIEIPxT
# sYVQSeqDDYOk/pKf3v5Sfn30XjoMxD4G5s7VGCzfMDcGCyqGSIb3DQEJEAIvMSgw
# JjAkMCIEINL25G3tdCLM0dRAV2hBNm+CitpVmq4zFq9NGprUDHgoMA0GCSqGSIb3
# DQEBAQUABIICAGgGZjTOHv6aL1XBiYjjAnL2kRDXHrQbHTZ338sIyDnTzoofzMcF
# Ao/L9OzsE5a2wgiWwwy0KDPnDj5nAWyR9FJ4q4OIk9eYfuhPNhB7YH2R3Cpdt+YN
# rVXbnSYaqcLm1jvnf8c6VZWeYDnCxecpzY5ZT4yDeVmQ4OI87jS+K5gvpHcqeUio
# US480huljgyP578VFGEBOH0BMrTr+YJnpfVHP34mA9bBtRyKuJgKVTW7FGrePfmj
# 61vUFEijnZLWhilgbHwghQ0985yttCxpBEO9NOjUKNvX51jZLW+gkiROELSvWH0c
# ytajpynr5K3h9KYPAj7ZRtrwrLXsPMDX9S6JQQt5gWTtAC1JwFxuzboIqtHPaU6h
# R1uybpFlrUKBxeWHiw6VEemo9S9uUPJMUSDJeuETr3hVVg8oHVlpR5fUS0KQUCAk
# F9bcEAorlC7NgVgZG/joRAE0hHiNCnIrq6xPH3E0TasU4J3gdKfZiCktCCq3JcNr
# fZTPU3oqr0pUJpJnHEaCm9oYnihAHXt5l1sG5V0wIXnV0DyqDxZ+duxGRK53UjiR
# vrwqUOLHH7xED3zFBwKNhtfAOt94KLfQIFvUJXOeADtlPg2oo3FSkx0pd5KuDXpm
# 8YHD2HYqVbc3LipSWLb05SPsDsmL2rJOBsTMGttqtDbNauvaMZRAsO8D
# SIG # End signature block