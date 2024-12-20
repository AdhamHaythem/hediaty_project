# Define adb path
$adbPath = "C:\Users\adham\AppData\Local\Android\Sdk\platform-tools\adb.exe"

# Start screen recording
$recordingProcess = Start-Process -FilePath $adbPath -ArgumentList "shell screenrecord /sdcard/test_rec.mp4" -NoNewWindow -PassThru
Write-Host "Starting recording..."

# Wait for a few seconds
Start-Sleep -Seconds 5

# Run integration test
Write-Host "Starting test script..."
Start-Process -FilePath "flutter" -ArgumentList "test integration_test/app_test.dart" -NoNewWindow -Wait

# Stop recording
Stop-Process -Id $recordingProcess.Id -ErrorAction Stop
Write-Host "Saving..."

# Wait for the recording to save
Start-Sleep -Seconds 3

# Pull the recording from the device
Start-Process -FilePath $adbPath -ArgumentList "pull /sdcard/test_rec.mp4" -NoNewWindow -Wait -ErrorAction Stop

Write-Host "Recording and test complete!"
Write-Host "You can exit..."
[System.Console]::ReadKey() | Out-Null