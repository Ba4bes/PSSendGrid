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
    if (-not[string]::IsNullOrEmpty($Parameter.AttachmentPath)) {
        $MailParameters.add("AttachmentPath", $Parameter.AttachmentPath)
    }
    if (-not[string]::IsNullOrEmpty($Parameter.AttachmentDisposition)) {
        $MailParameters.add("AttachmentDisposition", $Parameter.AttachmentDisposition)
    }
    if (-not[string]::IsNullOrEmpty($Parameter.AttachmentID)) {
        $MailParameters.add("AttachmentID", $Parameter.AttachmentID)
    }
    Send-PSSendGridMail @MailParameters
}

$parameter


$Parameters = @{
    FromAddress     = "example@neehenk.nl"
    ToAddress       = "barbara@barbaraforbes.nl"
    Subject         = "SendGrid Plain Example"
    Body            = "This is a plain text email"
    Token           = "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"
    FromName        = "Barbara"
    ToName          = "Barbara"
}
Send-PSSendGridMail @Parameters