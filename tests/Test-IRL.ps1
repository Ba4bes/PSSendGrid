# This file is used for IRL tests
$parameteroptions = Import-Csv .\tests\testparameters.csv -Delimiter ';'


foreach ($parameter in $parameteroptions) {

    $MailParameters = @{
        FromAddress = $Parameter.FromAddress
        ToAddress   = $Parameter.ToAddress
        Subject     = $parameter.Subject
        Token       = "TOKENHERE"
        FromName    = $parameter.FromName
        ToName      = $parameter.ToName
    }
    if (-not[string]::IsNullOrEmpty($Parameter.Body)) {
        $MailParameters.add("Body", $Parameter.Body)
    }
    if (-not[string]::IsNullOrEmpty($Parameter.BodyHTML)) {
        $MailParameters.add("BodyAsHTML", $Parameter.BodyHTML)
    }
    if (-not[string]::IsNullOrEmpty($Parameter.AttachementPath)) {
        $MailParameters.add("AttachementPath", $Parameter.AttachementPath)
    }
    if (-not[string]::IsNullOrEmpty($Parameter.AttachementDisposition)) {
        $MailParameters.add("AttachementDisposition", $Parameter.AttachementDisposition)
    }
    if (-not[string]::IsNullOrEmpty($Parameter.AttachementID)) {
        $MailParameters.add("AttachementID", $Parameter.AttachementID)
    }
    Send-PSSendGridMail @MailParameters
}

$parameter