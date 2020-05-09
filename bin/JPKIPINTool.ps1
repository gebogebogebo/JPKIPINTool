Set-Location (Split-Path ( & { $myInvocation.ScriptName } ) -parent)
Add-Type -Path ".\JPKIReader.dll";

Write-Host "カードリーダーにマイナンバーカードが乗っているかどうかチェックします"

$result = [JPKIReaderLib.JPKIReader]::IsJPKICardExist()

if( $result -eq $false ) {
    Write-Host "- マイナンバーカードが認識できませんでした"
    return
}
Write-Host "- マイナンバーカード認識OK!"
Write-Host "---"


Write-Host "利用者証明用パスワード（4桁の数字）　いわゆる　認証 PINのリトライ回数をチェックします"
$result = [JPKIReaderLib.JPKIReader]::GetAuthenticationPINRetryCount()
$message = "- PINリトライ回数 = " + $result + "回"
Write-Host $message
Write-Host "---"

Write-Host "署名用パスワード（半角6文字-16文字）　いわゆる　署名 PINのリトライ回数をチェックします"
$result = [JPKIReaderLib.JPKIReader]::GetSignaturePINRetryCount()
$message = "- PINリトライ回数 = " + $result + "回"
Write-Host $message
Write-Host "---"

