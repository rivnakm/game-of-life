function Get-Cell([Int]$Row, [Int]$Col, [Int]$Height, [Int]$Width, [Bool[]]$Cells) {
    if ($Row -ge 0 -and $Col -ge 0 -and $Row -lt $Height -and $Col -lt $Width) {
        return $Cells[($Row*$Width)+$Col]
    }
    else {
        return 0
    }
}

function Next-Generation() {
    $CellsCopy = $Cells.Clone()
    for ($i = 0; $i -lt $Height; $i++) {
        for ($j = 0; $j -lt $Width; $j++) {
            $Cell = Get-Cell $i $j $Height $Width $CellsCopy
            $Adjacent = 0

            for ($n = -1; $n -le 1; $n++) {
                for ($m = -1; $m -le 1; $m++) {
                    if ($n -eq 0 -and $m -eq 0) {
                        continue
                    }
                    if (Get-Cell ($i+$n) ($j+$m) $Height $Width $CellsCopy) {
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
$Height = 30
$Width = 30

$Cells = @(1..($Height*$Width))
for ($i = 0; $i -lt $Cells.Count; $i++) {
    $Cells[$i] = Get-Random -InputObject ([bool]$True,[bool]$False)
}

for ($i = 0; $i -lt $Generations; $i++) {
    Draw-Screen
    Write-Host "`e[${Height}A" -NoNewline
    Next-Generation
}