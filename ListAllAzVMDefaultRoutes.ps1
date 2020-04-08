
#------------------------------------------------------------------------------   
#   
#    
# THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT   
# WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT   
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS   
# FOR A PARTICULAR PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR    
# RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.   
#   
#------------------------------------------------------------------------------  

#Function to List VMs with Default Route and Route details



function List-AllAzVMDefaultRoutes {
Param(

[Switch]$NextHopTypeDefault,
[Switch]$NextHopTypeother,
[Switch]$NextHopTypeany


)


$getrunningvm1 = @()
$runningNIC = @()
$runningNICRG = @()
$runningVm = @()
$testnic = @()
$testvm = @()
$getvmr = Get-AzVM -Status

foreach ($power in $getvmr ){
if($Power.powerstate -like "*running*"){ $runningNIC += $power.NetworkProfile.NetworkInterfaces.id | Split-Path -Leaf 
$runningNICRG += $power.NetworkProfile.NetworkInterfaces.id | ForEach-Object {$_ -replace ".*/resourceGroups/" -replace "/.*"}

$runningVm += $power.Name
}
}
#$runningNIC.Count

for($i=0;$i -lt $runningNIC.Count; $i++){

$getrunningnic = Get-AzNetworkInterface -Name $runningNIC[$i] -ResourceGroupName $runningNICRG[$i]
$getrunningvm1 += $getrunningnic.VirtualMachine.Id | Split-Path -Leaf
$getInternetRoute = Get-AzEffectiveRouteTable -NetworkInterfaceName $runningNIC[$i]  -ResourceGroupName $runningNICRG[$i] 
$testvm += $getrunningvm1 
$testnic += $runningNIC

if($NextHopTypeDefault -eq $true){
$getInternetRoute2 = $getInternetRoute  | Where-Object {$_.NextHopType -eq "Internet" -and $_.State -eq 'Active' -and $_.AddressPrefix -eq '0.0.0.0/0'}
if ($getInternetRoute2)
{#"VM Name: $($testvm[$i])  "
#"NIC Name: $($testnic[$i]) "
"VMName                     : $($getrunningvm1[$i])"
"NICName                    : $($getrunningnic.Name)"
$($getInternetRoute2)}  

}


if($NextHopTypeother -eq $true){
$getInternetRoute2 = $getInternetRoute  | Where-Object {$_.NextHopType -ne "Internet"  -and $_.State -eq 'Active' -and $_.AddressPrefix -eq '0.0.0.0/0'}
if ($getInternetRoute2)
{#"VM Name: $($testvm[$i])  "
#"NIC Name: $($testnic[$i]) "
"VMName                     : $($getrunningvm1[$i])"
"NICName                    : $($getrunningnic.Name)"
$($getInternetRoute2)}  

}


if($NextHopTypeany -eq $true){
$getInternetRoute2 = $getInternetRoute  | Where-Object {$_.State -eq 'Active' -and $_.AddressPrefix -eq '0.0.0.0/0'}
if ($getInternetRoute2)
{#"VM Name: $($testvm[$i])  "
#"NIC Name: $($testnic[$i]) "
"VMName                     : $($getrunningvm1[$i])"
"NICName                    : $($getrunningnic.Name)"
$($getInternetRoute2)}  


}

if ($NextHopTypeany -eq $false -and $NextHopTypeother -eq $false -and $NextHopTypeDefault -eq $false)
{
$getInternetRoute2 = $getInternetRoute  | Where-Object {$_.State -eq 'Active' -and $_.AddressPrefix -eq '0.0.0.0/0'}
if ($getInternetRoute2)
{#"VM Name: $($testvm[$i])  "
#"NIC Name: $($testnic[$i]) "
"VMName                     : $($getrunningvm1[$i])"
"NICName                    : $($getrunningnic.Name)"
$($getInternetRoute2)}  


}

}

}

