Function Remove-Diacritics {
    # remove al special characters
    [CmdletBinding()]
    param(
        [parameter(Position = 1)]
        [string]$Value
    )
    $Value = $Value.Replace("ẞ", "ss")
    $TextWithoutDiacritics = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($Value))
    if ($Value -ne $TextWithoutDiacritics) {
        Write-Verbose "Replaced $Value with $TextWithoutDiacritics"
    }
    $TextWithoutDiacritics
}

function New-AddressArray {
    # Create an array with all the address data
    [outputtype([array])]
    [CmdletBinding()]
    param(
        [parameter(Position = 0)]
        [string[]]$Addresses,
        [parameter(Position = 1)]
        [string[]]$Names
    )

    $AllAddresses = @()
    $i = 0
    if ( $Addresses.Count -eq 0) {
        Write-Verbose "No addresses found, moving on"
    }
    else {
        Write-Verbose "Found $($Addresses.Count) addresses"
        foreach ($AddressValue in $Addresses) {
            Write-Verbose "Processing Address $($i) Value: $($AddressValue)"


            try {
                $null = [mailaddress]$AddressValue
                $null = Resolve-DnsName -Name ($AddressValue -as [mailaddress]).Host -Type 'MX' -ErrorAction Stop
            }
            catch {
                Throw "Invalid email address: $AddressValue"
            }
            $AddressObject = [pscustomObject]@{
                "email" = (Remove-Diacritics $AddressValue)
            }
            if ($Names.Count -gt $i) {
                $AddressObject | Add-Member -MemberType NoteProperty -Name "Name" -Value (Remove-Diacritics $Names[$i])
            }
            Write-Verbose "Added Name $($AddressObject.Name) to AddressObject"
            $AllAddresses += $AddressObject
            # }
            $i++
        }
        $AllAddresses
    }
}

Function Send-PSSendGridMail {
    <#
    .SYNOPSIS
    Send an email through the SendGrid API
    .DESCRIPTION
    This function is a wrapper around the SendGrid API.
    It is possible to send attachments as well.
    .PARAMETER ToAddress
    Emailaddress of the receiving end, multiple addresses can be entered in an array
    .PARAMETER ToName
    Name of the receiving end, multiple names can be entered in an array.
    When using multiple addresses, the ToName array must be in the same order as the ToAddress array.
    .PARAMETER FromAddress
    Source email address
    .PARAMETER FromName
    Source name
    .PARAMETER CcAddress
    Emailaddress of the CC recipient, multiple addresses can be entered in an array.
    .PARAMETER CcName
    Name of the CC recipient, multiple names can be entered in an array.
    When using multiple addresses, the CcName array must be in the same order as the CcAddress array.
    .PARAMETER BccAddress
    Emailaddress of the BCC recipient, multiple addresses can be entered in an array.
    .PARAMETER BccName
    Name of the BCC recipient, multiple names can be entered in an array.
    When using multiple addresses, the BccName array must be in the same order as the BccAddress array.
    .PARAMETER Subject
    Subject of the email
    .PARAMETER Body
    Body of the email when using plain text
    .PARAMETER BodyAsHTML
    Body of the email when using HTML
    .PARAMETER Token
    SendGrid token for the API
    .PARAMETER AttachmentPath
    Path to file(s) that needs to be attached.
    This can be a single string or an array of strings
    .PARAMETER AttachmentDisposition
    Attachment or Inline. Use inline to add image to HTML body
    .PARAMETER AttachmentID
    AttachmentID(s) for inline attachment, to refer to from the HTML.
    This can be a single string or an array of strings
    For multiple Attachments, the IDs should be in the same order as the attachmentPaths
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
    .EXAMPLE
    $Parameters = @{
        FromAddress     = "example@example.com"
        ToAddress       = @("example2@example.com", "example3@example.com")
        cCAddress       = "Example4@example.com"
        Subject         = "SendGrid example"
        Body            = "This is a plain text email"
        Token           = "adfdasfaihghaweoigneawfaewfawefadfdsfsd4tg45h54hfawfawfawef"
        FromName        = "Jane Doe"
        ToName          = @("John Doe", "Bert Doe")
    }
    Send-PSSendGridMail @Parameters

    =======
    Sends an email from example@example.com to example2@example.com and example3@example.com, with CC to Example4@example.com
    .LINK
    https://github.com/Ba4bes/PSSendGrid
    .LINK
    https://4bes.nl/2020/07/26/pssendgrid-send-email-from-powershell-with-sendgrid/
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
        [string[]]$ToAddress,
        [parameter(Mandatory = $False)]
        [string[]]$ToName,
        [parameter(Mandatory = $True)]
        [string]$FromAddress,
        [parameter(Mandatory = $False)]
        [string]$FromName,
        [parameter(Mandatory = $False)]
        [string[]]$CCAddress,
        [parameter(Mandatory = $False)]
        [string[]]$CCName,
        [parameter(Mandatory = $False)]
        [string[]]$BCCAddress,
        [parameter(Mandatory = $False)]
        [string[]]$BCCName,
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
        [string[]]$AttachmentPath,
        [parameter()]
        [ValidateSet('attachment', 'inline')]
        [string]$AttachmentDisposition = "attachment",
        [parameter()]
        [string[]]$AttachmentID

    )
    # Collect initial variables
    $StartVariables = (Get-Variable).Name

    Write-Verbose "Starting Function Send-PSSendGridMail"
    # Set body as HTML or as text
    if (-not[string]::IsNullOrEmpty($BodyAsHTML)) {
        $MailbodyType = 'text/HTML'
        $MailbodyValue = (Remove-Diacritics $BodyAsHTML)
        Write-Verbose "Found BodyAsHTML parameter, Type is set to text/HTML"
    }
    else {
        $MailbodyType = 'text/plain'
        $MailBodyValue = (Remove-Diacritics $Body)
        Write-Verbose "Found no BodyAsHTML parameter, Type is set to text/plain"
    }
    # Check for attachments. If they are present, convert to Base64
    if ($AttachmentPath) {
        Write-Verbose "AttachmentPath parameter was used"
        $AllAttachments = @()
        foreach ($Attachment in $AttachmentPath) {
            try {
                if ($PSVersionTable.PSVersion.Major -lt 6) {
                    $EncodedAttachment = [convert]::ToBase64String((Get-Content $Attachment -encoding byte))
                }
                else {
                    $AttachmentContent = Get-Content -Path $Attachment -AsByteStream -ErrorAction Stop

                    $EncodedAttachment = [convert]::ToBase64String($AttachmentContent)
                }
                Write-Verbose "Attachment found at $Attachment has been encoded"
            }
            Catch {

                Throw "Could not convert file $Attachment"
            }


            # Get the extension for the attachment type
            $AttachmentExtension = $Attachment.Split('.')[-1]
            Switch ($IsWindows) {
                $true { $AttachmentName = $Attachment.Split('\')[-1] }
                $false { $AttachmentName = $Attachment.Split('/')[-1] }
                $Null { $AttachmentName = $Attachment.Split('\')[-1] }
                default {
                    Throw "Could not work with attachmentpath"
                }
            }
            Write-Verbose "AttachmentExtension: $AttachmentExtension"
            $ImageExtensions = @("jpg", "png", "gif")
            if ($ImageExtensions -contains $AttachmentExtension) {
                $Type = "image/$AttachmentExtension"
                Write-Verbose "Attachment is an image, type set to $Type"
            }
            else {
                $Type = "Application/$AttachmentExtension"
                Write-Verbose "Attachment is not an image, type set to $Type"
            }
            $Attachmentobject = [pscustomObject]@{
                AttachmentName    = $AttachmentName
                EncodedAttachment = $EncodedAttachment
                AttachmentType    = $Type
            }
            $AllAttachments += $Attachmentobject
        }
        Write-Verbose "$($AllAttachments.Count) attachments have been processed"
    }
    # Create to, cc, bcc objects if needed
    Write-Verbose "Adding toAddress array if needed"
    $ToAddresses = New-AddressArray -Addresses $ToAddress -Names $ToName
    Write-Verbose "Adding ccAddress array if needed"
    $CCAddresses = New-AddressArray -Addresses $CCAddress -Names $CCName
    Write-Verbose "Adding bccAddress array if needed"
    $BCCAddresses = New-AddressArray -Addresses $BCCAddress -Names $BCCName

    Write-Verbose "Creating SendGrid object"


    # Create a body to send to the API

    $Personalization = @{
        'subject' = (Remove-Diacritics $Subject)
    }
    Write-Verbose "adding subject: $($Personalization.subject)"
    if ($ToAddresses) {
        $Personalization.Add('to', @($ToAddresses))
    }
    if ($CCAddresses) {
        $Personalization.Add("cc", @($CCAddresses))
    }
    if ($BCCAddresses) {
        $Personalization.Add("bcc" , @($BCCAddresses))
    }
    $SendGridBody = [pscustomObject]@{
        "personalizations" = @(
            $Personalization
        )
        "content"          = @(
            @{
                "type"  = $mailbodyType
                "value" = $MailBodyValue
            }
        )
        "from"             = @{
            "email" = (Remove-Diacritics $FromAddress)
            "name"  = (Remove-Diacritics $FromName)
        }
    }

    # Add attachments to body if they are present
    if ($AttachmentPath) {
        $Attachments = @()
        $i = 0
        foreach ($Attachmentobject in $AllAttachments) {
            Write-Verbose "Attachment is added to body"
            $Object = @{
                content     = $Attachmentobject.EncodedAttachment
                filename    = $Attachmentobject.AttachmentName
                type        = $Attachmentobject.AttachmentType
                disposition = $AttachmentDisposition
            }
            if ($AttachmentID) {
                # AttachmentIDs are added in the same order as the attachments
                $Object.add("content_id", $AttachmentID[$i])
            }
            $Attachments += $Object
            $i++
            Write-Verbose "Attachment Filename: $($Object.filename)"
            Write-Verbose "Attachment type: $($Object.type)"
            Write-Verbose "Attachment disposition: $($object.disposition)"
            Write-Verbose "Attachment ObjectID: $($object.content_id)"
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
    #Remove the variables that were added by the function
    $NewVariables = Get-Variable | Where-Object { $StartVariables -notcontains $_.Name }
    Clear-Variable $NewVariables.Name -ErrorAction SilentlyContinue
    Write-Verbose "API has been called, function is done"
}