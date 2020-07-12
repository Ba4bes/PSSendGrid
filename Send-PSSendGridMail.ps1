Function Send-PSSendGridMail {
    param (
        [cmdletbinding()]
        [parameter()]
        [string]$ToAddress,
        [parameter()]
        [string]$ToName,
        [parameter()]
        [string]$FromAddress,
        [parameter()]
        [string]$FromName,
        [parameter()]
        [string]$Subject,
        [parameter()]
        [string]$Body,
        [parameter()]
        [string]$BodyAsHTML,
        [parameter()]
        [string]$Token,
        [parameter()]
        [string]$AttachementPath,
        [parameter()]
        [string]$AttachementDisposition

    )
    if (-not[string]::IsNullOrEmpty($BodyAsHTML)) {
        $MailbodyType = 'text/HTML'
        $MailbodyValue = $BodyAsHTML
    }
    else {
        $MailbodyType = 'text/plain'
        $MailBodyValue = $Body
    }

    # Encode attachement
    # $Attachement = get-content $AttachementPath
    # [System.Text.Encoding]::Unicode
    # $Bytes = [System.Text.Encoding]::Unicode.GetBytes($Attachement)
    # $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Attachement)
    # $EncodedAttachement = [System.Convert]::ToBase64String($Bytes).
    # [convert]::ToBase64String((get-content $path -encoding byte))
    if ($AttachementPath) {
        $AttachementContent = Get-Content -Path $AttachementPath -AsByteStream
        if ([string]::IsNullOrEmpty($AttachementContent)) {
                Throw "File content is empty, attachement can not be saved"
            }
            $EncodedAttachement = [convert]::ToBase64String($AttachementContent)
            $AttachementExtension = $AttachementPath.Split('.')[-1]
            Switch ($IsWindows) {
                $true { $AttachementName = $AttachementPath.Split('\')[-1] }
                $false { $AttachementName = $AttachementPath.Split('/')[-1] }
                $Null { $AttachementName = $AttachementPath.Split('\')[-1] }
                default {
                    Throw "Could not work with Attachementpath"
                }
            }
            $ImageExtensions = @("jpg", "png", "gif")
            if ($ImageExtensions -contains $AttachementExtension) {
                $Type = "image/$AttachementExtension"
            }
            else {
                $Type = "Application/$AttachementExtension"
            }
        }

        # Create a body for sendgrid
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
            # "attachments"      = @(
            #     @{
            #         content     = $EncodedAttachement
            #         filename    = $AttachementName
            #         type        = $Type
            #         disposition = "attachment"
            #     }
            # )
        }
        if ($AttachementPath){
            $attachments      = @(
                @{
                    content     = $EncodedAttachement
                    filename    = $AttachementName
                    type        = $Type
                    disposition = $AttachementDisposition
                }
            )
            $SendGridBody | Add-Member -MemberType NoteProperty -Name "attachments" -Value $attachments
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
        Invoke-RestMethod @Parameters
    }

    $Parameters = @{
        FromAddress     = "meuk@neehenk.nl"
        ToAddress       = "example@example.nl"
        Subject         = "SendGrid test"
        Body            = "Dit is een mail"
        Token           = ""
        FromName        = "Henk"
        ToName          = "Barbara"
        AttachementPath = "C:\Scripts\GIT\Github\PSSendGrid\capture.txt"
        AttachementDisposition = "attachment"
    }
    Send-PSSendGridMail @Parameters
