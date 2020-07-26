Function Send-PSSendGridMail {
    <#
    .SYNOPSIS
    Send an email through the SendGrid API
    .DESCRIPTION
    This function is a wrapper around the SendGrid API.
    It is possible to send attachments as well.
    .PARAMETER ToAddress
    Emailaddress of the receiving end
    .PARAMETER ToName
    Name of the receiving end
    .PARAMETER FromAddress
    Source email address
    .PARAMETER FromName
    Source name
    .PARAMETER Subject
    Subject of the email
    .PARAMETER Body
    Body of the email when using plain text
    .PARAMETER BodyAsHTML
    Body of the email when using HTML
    .PARAMETER Token
    SendGrid token for the API
    .PARAMETER AttachmentPath
    Path to file that needs to be attached
    .PARAMETER AttachmentDisposition
    Attachment or Inline. Use inline to add image to HTML body
    .PARAMETER AttachmentID
    AttachmentID for inline attachment, to refer to from the HTML
    .EXAMPLE
    $Parameters = @{
        FromAddress     = "example@example.com"
        ToAddress       = "example2@example.com"
        Subject         = "SendGrid example"
        Body            = "This is a plain text email"
        Token           = "adfdasfaihghaweoigneawfaewfawefadfdsfsd4tg45h54hfawfawfawef"
        FromName        = "Jane Doe"
        ToName          = "John Doe"
    }
    Send-PSSendGridMail @Parameters

    =======
    Sends an email from example@example.com to example2@example.com

    .EXAMPLE
    $Parameters = @{
        Token      = "API TOKEN"
        ToAddress  = "example@example.com"
        BodyAsHTML = "<h1>MetHTML</h1><img src='cid:exampleID'>"
        ToName                   =      "Example2"
        FromName                 =      "Example1"
        FromAddress              =      "example2@example.com"
        AttachmentID            =      "exampleID"
        AttachmentPath          =      "C:\temp\exampleimage.jpg"
        AttachmentDisposition   =      "inline"
        Subject                  =      "Test"
    }
    Send-PSSendGridMail @Parameters

    =======
    Sends an email with an inline attachment in the HTML
    .LINK
    https://github.com/Ba4bes/PSSendGrid
    .NOTES
    Created by Barbara Forbes
    Script has been tested for Windows PowerShell and PowerShell 7.
    Only has been tested on Windows.
    @Ba4bes
    https://4bes.nl

    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory = $True)]
        [ValidatePattern('^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$')]
        [string]$ToAddress,
        [parameter(Mandatory = $True)]
        [string]$ToName,
        [parameter(Mandatory = $True)]
        [ValidatePattern('^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$')]
        [string]$FromAddress,
        [parameter(Mandatory = $True)]
        [string]$FromName,
        [parameter(Mandatory = $True)]
        [string]$Subject,
        [parameter()]
        [string]$Body,
        [parameter()]
        [string]$BodyAsHTML,
        [parameter(Mandatory = $True)]
        [string]$Token,
        [parameter()]
        [ValidateScript( { Test-Path $_ })]
        [string]$AttachmentPath,
        [parameter()]
        [ValidateSet('attachment', 'inline')]
        [string]$AttachmentDisposition = "attachment",
        [parameter()]
        [string]$AttachmentID

    )
    # Set body as HTML or as text
    if (-not[string]::IsNullOrEmpty($BodyAsHTML)) {
        $MailbodyType = 'text/HTML'
        $MailbodyValue = $BodyAsHTML
    }
    else {
        $MailbodyType = 'text/plain'
        $MailBodyValue = $Body
    }
    # Check for attachtements. If they are present, convert to Base64
    if ($AttachmentPath) {
        try {
            if ($PSVersionTable.PSVersion.Major -lt 6) {
                $EncodedAttachment = [convert]::ToBase64String((get-content $Attachmentpath -encoding byte))
            }
            else {
                $AttachmentContent = Get-Content -Path $AttachmentPath -AsByteStream -ErrorAction Stop

                $EncodedAttachment = [convert]::ToBase64String($AttachmentContent)
            }
        }
        Catch {

            Throw "Could not convert file $AttachmentPath"
        }

        # Get the extension for the attachment type
        $AttachmentExtension = $AttachmentPath.Split('.')[-1]
        Switch ($IsWindows) {
            $true { $AttachmentName = $AttachmentPath.Split('\')[-1] }
            $false { $AttachmentName = $AttachmentPath.Split('/')[-1] }
            $Null { $AttachmentName = $AttachmentPath.Split('\')[-1] }
            default {
                Throw "Could not work with attachmentpath"
            }
        }
        $ImageExtensions = @("jpg", "png", "gif")
        if ($ImageExtensions -contains $AttachmentExtension) {
            $Type = "image/$AttachmentExtension"
        }
        else {
            $Type = "Application/$AttachmentExtension"
        }
    }

    # Create a body to send to the API
    $SendGridBody = [pscustomObject]@{
        "personalizations" = @(
            @{
                "to"      = @(
                    @{
                        "email" = $ToAddress
                        "name"  = $ToName
                    }
                )
                "subject" = $Subject
            }
        )
        "content"          = @(
            @{
                "type"  = $mailbodyType
                "value" = $MailBodyValue
            }
        )
        "from"             = @{
            "email" = $FromAddress
            "name"  = $FromName
        }
    }
    # Add attachments to body if they are present
    if ($AttachmentPath) {
        $Attachments = @(
            @{
                content     = $EncodedAttachment
                filename    = $AttachmentName
                type        = $Type
                disposition = $AttachmentDisposition
            }
        )
        if ($AttachmentID) {
            $Attachments[0].add("content_id", $AttachmentID)
        }
        $SendGridBody | Add-Member -MemberType NoteProperty -Name "Attachments" -Value $Attachments
    }
    $BodyJson = $SendGridBody | ConvertTo-Json -Depth 4

    #Create the header
    $Header = @{
        "authorization" = "Bearer $token"
    }
    #send the mail through Sendgrid
    $Parameters = @{
        Method      = "POST"
        Uri         = "https://api.sendgrid.com/v3/mail/send"
        Headers     = $Header
        ContentType = "application/json"
        Body        = $BodyJson
    }
    if ($PSCmdlet.ShouldProcess(
            ("An email will be send from {0} to {1} with subject: {2}" -f $SendGridBody.from.email, $SendGridBody.personalizations.to.email, $SendGridBody.personalizations.subject),
            ("Do you want to send an email from {0} to {1} with subject: {2}?" -f $SendGridBody.from.email, $SendGridBody.personalizations.to.email, $SendGridBody.personalizations.subject),
            "Send email")) {
        Invoke-RestMethod @Parameters
    }
}