function Next-Generation() {
    $CellsCopy = $Cells.Clone()
    for ($i = 0; $i -lt $Height; $i++) {
        for ($j = 0; $j -lt $Width; $j++) {
            $Cell = $CellsCopy[($i*$Width)+$j]
            $Adjacent = 0

            for ($n = -1; $n -le 1; $n++) {
                for ($m = -1; $m -le 1; $m++) {
                    if ($n -eq 0 -and $m -eq 0) {
                        continue
                    }
                    $Row = $i + $n
                    $Col = $j + $m
                    if (($Row -ge 0 -and $Col -ge 0 -and $Row -lt $Height -and $Col -lt $Width) -and $CellsCopy[($Row*$Width)+$Col]) {
                        $Adjacent++
                    }
                }
            }

            if ($Cell) {
                if ($Adjacent -lt 2) {
                    $Cell = $False
                }
                if ($Adjacent -gt 3) {
                    $Cell = $False
                }
            }
            else {
                if ($Adjacent -eq 3) {
                    $Cell = $True
                }
            }

            $Cells[($i*$Width)+$j] = $Cell
        }
    }
}

function Draw-Screen() {
    for ($Row = 0; $Row -lt $Height; $Row++) {
        for ($Col = 0; $Col -lt $Width; $Col++) {
            if ($Cells[($Row*$Width)+$Col] -eq 1) {
                Write-Host "██" -NoNewline
            }
            else {
                Write-Host "  " -NoNewline
            }
        }
        Write-Host ""
    }
}

$Generations = 500
$Height = 50
$Width = 100

$Cells = @(1..($Height*$Width))
for ($i = 0; $i -lt $Cells.Count; $i++) {
    $Cells[$i] = Get-Random -InputObject ([bool]$True,[bool]$False)
}

for ($i = 0; $i -lt $Generations; $i++) {
    Draw-Screen
    Write-Host "`e[${Height}A" -NoNewline
    Next-Generation
}