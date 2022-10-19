# This file is used for IRL tests
$parameteroptions = Import-Csv .\tests\testparameters.csv -Delimiter ';'


foreach ($parameter in $parameteroptions) {

    $MailParameters = @{
        FromAddress = $Parameter.FromAddress
        ToAddress   = ($Parameter.ToAddress -split ',')
        Subject     = $parameter.Subject
        Token       = "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"
        FromName    = $parameter.FromName
        ToName      = $parameter.ToName
    }
    if (-not[string]::IsNullOrEmpty($Parameter.Body)) {
        $MailParameters.add("Body", $Parameter.Body)
    }
    if (-not[string]::IsNullOrEmpty($Parameter.BodyHTML)) {
        $MailParameters.add("BodyAsHTML", $Parameter.BodyHTML)
    }
    if (-not[string]::IsNullOrEmpty($Parameter.AttachmentPath)) {
        [string[]]$AttachmentPaths = ($parameter.AttachmentPath).split(',')
        $MailParameters.add("AttachmentPath", $AttachmentPaths)
    }
    if (-not[string]::IsNullOrEmpty($Parameter.AttachmentDisposition)) {
        $MailParameters.add("AttachmentDisposition", $Parameter.AttachmentDisposition)
    }
    if (-not[string]::IsNullOrEmpty($Parameter.AttachmentID)) {
        [string[]]$AttachmentID = ($parameter.AttachmentID).split(',')
        $MailParameters.add("AttachmentID", $AttachmentID)
    }
    if (-not[string]::IsNullOrEmpty($Parameter.ccAddress)) {
        $MailParameters.add("ccAddress", ($Parameter.ccAddress).split(','))
    }
    if (-not[string]::IsNullOrEmpty($Parameter.ccName)) {
        $MailParameters.add("ccName", ($Parameter.ccName).split(','))
    }
    if (-not[string]::IsNullOrEmpty($Parameter.bccAddress)) {
        $MailParameters.add("bccAddress", ($Parameter.bccAddress).split(','))
    }
    if (-not[string]::IsNullOrEmpty($Parameter.bccName)) {
        $MailParameters.add("bccName", ($Parameter.bccName).split(','))
    }
    Send-PSSendGridMail @MailParameters -Verbose
}
