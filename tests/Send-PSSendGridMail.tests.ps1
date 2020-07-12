# Copied from https://powershellexplained.com/2017-01-21-powershell-module-continious-delivery-pipeline/
BeforeAll{
$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force
}

Describe "General project validation: $moduleName" {

    $scripts = Get-ChildItem $projectRoot -Include *.ps1, *.psm1, *.psd1 -Recurse

    # TestCases are splatted to the script so we need hashtables
    $testCase = $scripts | Foreach-Object {
        @{
            file = $_
        }
    }

    It "Script <file> should exist" -TestCases $testCase {
        param($file)

        $file.fullname | Should -Exist
    }

    It "Script <file> can be read without errors" -TestCases $testCase {
        param($file)

        { $null = Get-Content -Path $file.fullname -ErrorAction Stop } | Should -Not -Throw
    }

    It "Script <file> should be valid powershell" -TestCases $testCase {
        param($file)

        $contents = Get-Content -Path $file.fullname -ErrorAction SilentlyContinue
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should -Be 0
    }

    It "Module '$moduleName' can import cleanly" {
        { Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force } | Should -Not -Throw
    }
}
