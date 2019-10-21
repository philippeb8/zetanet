<?php
header('Content-Type: text/html; charset=utf-8');

// Assertions
if ($_GET[imageid] == "") die('Missing parameter: imageid');

// Hardcoded variables:
$username = "zetanethost";
$password = "xxx";

// Connecting, selecting database
$link = mysqli_connect('localhost', $username, $password, 'zetanet_host');

// Check connection
if (mysqli_connect_errno())
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
            
mysqli_set_charset($link, "utf8");

$query = "SELECT image FROM siteimage WHERE imageid = $_GET[imageid]";

$result = mysqli_query($link, $query);
                                        
if (! $result)
    echo "Query failed: " . mysqli_error($link);

// Printing results in HTML
while ($line = mysqli_fetch_array($result, MYSQLI_ASSOC)) 
{
    echo $line[image];
}

// Closing connection
mysqli_close($link);
?>
