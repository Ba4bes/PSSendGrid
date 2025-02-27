---
external help file: PSSendGrid-help.xml
Module Name: PSSendGrid
online version: https://github.com/Ba4bes/PSSendGrid
schema: 2.0.0
---

# Send-PSSendGridMail

## SYNOPSIS
Send an email through the SendGrid API

## SYNTAX

```
Send-PSSendGridMail [-ToAddress] <String[]> [[-ToName] <String[]>] [-FromAddress] <String>
 [[-FromName] <String>] [[-CCAddress] <String[]>] [[-CCName] <String[]>] [[-BCCAddress] <String[]>]
 [[-BCCName] <String[]>] [-Subject] <String> [[-Body] <String>] [[-BodyAsHTML] <String>] [-Token] <String>
 [[-ApiEndpoint] <Uri>] [[-AttachmentPath] <String[]>] [[-AttachmentDisposition] <String>]
 [[-AttachmentID] <String[]>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is a wrapper around the SendGrid API.
It is possible to send attachments as well.

## EXAMPLES

### EXAMPLE 1
```
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
```

=======
Sends an email from example@example.com to example2@example.com

### EXAMPLE 2
```
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
```

=======
Sends an email with an inline attachment in the HTML

### EXAMPLE 3
```
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
```

=======
Sends an email from example@example.com to example2@example.com and example3@example.com, with CC to Example4@example.com

## PARAMETERS

### -ToAddress
Emailaddress of the receiving end, multiple addresses can be entered in an array

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToName
Name of the receiving end, multiple names can be entered in an array.
When using multiple addresses, the ToName array must be in the same order as the ToAddress array.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FromAddress
Source email address

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FromName
Source name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CCAddress
Emailaddress of the CC recipient, multiple addresses can be entered in an array.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CCName
Name of the CC recipient, multiple names can be entered in an array.
When using multiple addresses, the CcName array must be in the same order as the CcAddress array.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BCCAddress
Emailaddress of the BCC recipient, multiple addresses can be entered in an array.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BCCName
Name of the BCC recipient, multiple names can be entered in an array.
When using multiple addresses, the BccName array must be in the same order as the BccAddress array.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subject
Subject of the email

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
Body of the email when using plain text

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BodyAsHTML
Body of the email when using HTML

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
SendGrid token for the API

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiEndpoint
The API endpoint to use for sending the email.
By default, it uses the Global endpoint https://api.sendgrid.com/v3/mail/send.
If you need to use the EU endpoint, you can override this parameter with \`https://api.eu.sendgrid.com/v3/mail/send\`.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: Https://api.sendgrid.com/v3/mail/send
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttachmentPath
Path to file(s) that needs to be attached.
This can be a single string or an array of strings

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttachmentDisposition
Attachment or Inline.
Use inline to add image to HTML body

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: Attachment
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttachmentID
AttachmentID(s) for inline attachment, to refer to from the HTML.
This can be a single string or an array of strings
For multiple Attachments, the IDs should be in the same order as the attachmentPaths

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Created by Barbara Forbes
Script has been tested for Windows PowerShell and PowerShell 7.
Only has been tested on Windows.
@Ba4bes
https://4bes.nl

## RELATED LINKS

[https://github.com/Ba4bes/PSSendGrid](https://github.com/Ba4bes/PSSendGrid)

[https://4bes.nl/2020/07/26/pssendgrid-send-email-from-powershell-with-sendgrid/](https://4bes.nl/2020/07/26/pssendgrid-send-email-from-powershell-with-sendgrid/)

