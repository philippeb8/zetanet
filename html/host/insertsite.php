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
$query = "INSERT INTO site (email, html) VALUES ('".addslashes($_POST[email])."', '".addslashes($_POST[html])."')";

$result = mysqli_query($link, $query);
                                        
if (! $result)
    echo "Query failed: " . mysqli_error($link);

// Printing results in JSON
echo "{\n";
echo "\t\"siteid\": \"".mysqli_insert_id($link)."\"\n";
echo "}\n";

// Closing connection
mysqli_close($link);
?>
