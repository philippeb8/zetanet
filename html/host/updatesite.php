<?php
header('Content-Type: text/html; charset=utf-8');

// Hardcoded variables:
$username = "zetanethost";
$password = "xxx";

// Connecting, selecting database
$link = mysqli_connect('localhost', $username, $password, 'zetanet_host');
            
// Check connection
if (mysqli_connect_errno())
    echo "Failed to connect to MySQL: " . mysqli_connect_error();

mysqli_set_charset($link, "utf8");

// Performing SQL query
$query = "UPDATE site SET email = '".addslashes($_POST[email])."', html = '".addslashes($_POST[html])."' WHERE siteid = '$_POST[siteid]'";

$result = mysqli_query($link, $query);
                                        
if (! $result)
    echo "Query failed: " . mysqli_error($link);

// Closing connection
mysqli_close($link);

echo "Site '$_POST[siteid]' successfully updated."
?>
