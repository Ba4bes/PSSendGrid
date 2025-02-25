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
Send-PSSendGridMail [-ToAddress] <String> [[-ToName] <String>] [-FromAddress] <String> [[-FromName] <String>]
 [-Subject] <String> [[-Body] <String>] [[-BodyAsHTML] <String>] [-Token] <String>
 [[-AttachmentPath] <String[]>] [[-AttachmentDisposition] <String>] [[-AttachmentID] <String[]>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is a wrapper around the SendGrid API.
It is possible to send attachments as well.

## EXAMPLES

### EXAMPLE 1
```
$Parameters = @{
    FromAddress     = "example@example.com"
    ToAddress       = "Example2@Example.com"
    Subject         = "SendGrid example"
    Body            = "This is a plain text email"
    Token           = "adfdasfaihghaweoigneawfaewfawefadfdsfsd4tg45h54hfawfawfawef"
    FromName        = "Jane Doe"
    ToName          = "John Doe"
}
Send-PSSendGridMail @Parameters
```

### EXAMPLE 2
```
$Parameters = @{
    Token      = "API TOKEN"
    ToAddress  = "example@example.com"
    BodyAsHTML = "<h1>MetHTML</h1><img src='cid:exampleID'>"
    ToName                   =      "Exampl2"
    FromName                 =      "Example1"
    FromAddress              =      "Example2@example.com"
    AttachmentID            =      "exampleID"
    AttachmentPath          =      "C:\temp\exampleimage.jpg"
    AttachmentDisposition   =      "inline"
    Subject                  =      "Test"
}
Send-PSSendGridMail @Parameters
```

## PARAMETERS

### -ToAddress
Emailaddress of the receiving end

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToName
Name of the receiving end

```yaml
Type: String
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

### -Subject
Subject of the email

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
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
Position: 6
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
Position: 7
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
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiEndpoint
The API endpoint to use for sending the email. By default, it uses the Global endpoint `https://api.sendgrid.com/v3/mail/send`. If you need to use the EU endpoint, you can override this parameter with `https://api.eu.sendgrid.com/v3/mail/send`.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: https://api.sendgrid.com/v3/mail/send
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttachmentPath
Path to file that needs to be attached

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttachmentDisposition
attachment or Inline.
Use inline to add image to HTML body

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: Attachment
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttachmentID
AttachmentID for inline attachment, to refer to from the HTML

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

