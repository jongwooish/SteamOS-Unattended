# VMware 스냅샷 자동 테스트 (Windows PowerShell에서 실행)
#
# 하는 일:
#   1) VM을 clean-install 스냅샷으로 되돌리고 켠다
#   2) 레포를 VM에 복사한다
#   3) dry-run -> 실제 실행 -> 다시 실행 순서로 돌린다
#   4) 마지막 실행이 "변경 0건"이면 PASS (멱등성 확인)
#
# 준비:
#   - SSH 키 로그인 설정 (docs/vmware-setup.md 의 "테스트 자동화 준비")
#   - clean-install 스냅샷에 SSH 키가 들어 있어야 함
#
# 예:
#   .\tests\vm-test.ps1
#   .\tests\vm-test.ps1 -Profile minimal -Vmx "D:\VMs\SteamOS\SteamOS.vmx"

param(
    [string]$Vmx      = "C:\VMs\SteamOS\SteamOS.vmx",
    [string]$Ip       = "192.168.126.133",
    [string]$Snapshot = "clean-install",
    [string]$Profile  = "full",
    [string]$VmRun    = "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe"
)

$ErrorActionPreference = "Stop"
$Repo = Split-Path -Parent $PSScriptRoot
$Ssh  = @("-o", "BatchMode=yes", "-o", "ConnectTimeout=5", "deck@$Ip")

function Step($msg) { Write-Host "`n:: $msg" -ForegroundColor Cyan }

function Fail($msg) { Write-Host "FAIL: $msg" -ForegroundColor Red; exit 1 }

if (-not (Test-Path $Vmx))   { Fail ".vmx 파일이 없습니다: $Vmx" }
if (-not (Test-Path $VmRun)) { Fail "vmrun.exe 가 없습니다: $VmRun" }

Step "스냅샷 '$Snapshot' 으로 되돌리기"
& $VmRun -T ws revertToSnapshot $Vmx $Snapshot
if ($LASTEXITCODE -ne 0) { Fail "스냅샷 '$Snapshot' 으로 되돌리지 못했습니다 (스냅샷 이름 확인)" }
& $VmRun -T ws start $Vmx nogui
if ($LASTEXITCODE -ne 0) { Write-Host "   (이미 켜져 있으면 무시해도 됩니다)" }

Step "SSH 대기 (최대 5분)"
$deadline = (Get-Date).AddMinutes(5)
do {
    Start-Sleep -Seconds 5
    ssh @Ssh "true" 2>$null
    $ok = ($LASTEXITCODE -eq 0)
} until ($ok -or (Get-Date) -gt $deadline)
if (-not $ok) { Write-Host "SSH 접속 실패" -ForegroundColor Red; exit 1 }

Step "레포 복사"
ssh @Ssh "rm -rf ~/steamos-unattended"
scp -o BatchMode=yes -r $Repo "deck@${Ip}:~/steamos-unattended" | Out-Null
ssh @Ssh "chmod +x ~/steamos-unattended/install.sh ~/steamos-unattended/modules/*.sh ~/steamos-unattended/lib/*.sh"

$results = @()
foreach ($run in @("--dry-run", "", "")) {
    $label = if ($run) { "dry-run" } else { "실행" }
    Step "$label (프로필: $Profile)"
    ssh -t @Ssh "cd ~/steamos-unattended && ./install.sh --profile $Profile $run"
    $code = $LASTEXITCODE
    $summary = ssh @Ssh "grep SUMMARY ~/.local/state/steamos-unattended/install.log | tail -1"
    $results += [pscustomobject]@{ Run = $label; Exit = $code; Summary = $summary }
}

Step "결과"
$results | Format-Table -AutoSize

$last = $results[-1]
if ($last.Exit -eq 0 -and $last.Summary -match "changed=0 .*failed=0") {
    Write-Host "PASS: 마지막 실행 변경 0건 (멱등)" -ForegroundColor Green
    exit 0
} else {
    Write-Host "FAIL: $($last.Summary)" -ForegroundColor Red
    exit 1
}
