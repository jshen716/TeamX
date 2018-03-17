Clear-Host
$path = ".\Microsoft.ServiceBus.dll"
Import-Module $path


#$connectionString = (get-content '.\connectionstring.txt') -join "`r`n"
#$connectionString = "Endpoint=sb://gze-mltasb-in1-bns-001.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=d8OSIaZ7Z6MTFGy8CyLZ0CKWvjU0c/x9+Q3pVexduIE="

$connectionString = "Endpoint=sb://ts-teamx.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=QamX06+/xrH66iydZadr38s4yuiTwfsrJeP1LjHSN90="
# my test data was just { "greeting":"Hello World" }
$payload = (Get-Content '.\testdata.json') -join "`r`n"
function SendMessage($message) {
    #$client = [Microsoft.ServiceBus.Messaging.QueueClient]::CreateFromConnectionString($connectionString)
    #$client = [Microsoft.ServiceBus.Messaging.QueueClient]::CreateFromConnectionString($connectionString, "gze-mltasb-in1-bqu-001")
    $client = [Microsoft.ServiceBus.Messaging.QueueClient]::CreateFromConnectionString($connectionString, "queue1")

    $message = New-Object Microsoft.ServiceBus.Messaging.BrokeredMessage($message);
    $message
    $client.Send($message)
    if ($client -ne $null) {
        $client.Close()
    }
}

function ReceiveMessage() {

    #$client = [Microsoft.ServiceBus.Messaging.QueueClient]::CreateFromConnectionString($connectionString, "testqueue")
    $client = [Microsoft.ServiceBus.Messaging.QueueClient]::CreateFromConnectionString($connectionString, "queue1","ReceiveAndDelete")
    #$client = [Microsoft.ServiceBus.Messaging.QueueClient]::CreateFromConnectionString($connectionString)


    $message = [Microsoft.ServiceBus.Messaging.BrokeredMessage] $client.Receive([System.TimeSpan]::FromSeconds(5))
    if ($message -ne $null) {
        Write-Host 'Message Id:' $message.MessageId
        

        $BindingFlags= [Reflection.BindingFlags] "Public,Instance"
        $generic_method = $message.GetType().GetMethod("GetBody",$BindingFlags,$null, @(),$null).MakeGenericMethod([String])
        $generic_method.Invoke($message,$null)

    }
    else {
        Write-Host 'Zero Message in the Queue'
    }
    
    $client.Close()
}






# Send Message to the Queue
for ( $i = 0; $i -lt 1; $i++ ) {
SendMessage $payload
}
<#
for ( $j = 0; $j -lt 10; $j++ ) {
# Receive Message from the Queue
ReceiveMessage
}#>