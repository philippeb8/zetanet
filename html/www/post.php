<?php
// Assertions
if ($_GET[postid] == "") die('Missing parameter: postid');

// Hardcoded variables:
$username = "zetanetuser";
$password = "xxx";

// Connecting, selecting database
$link = mysqli_connect('localhost', $username, $password, 'zetanet_main');

// Check connection
if (mysqli_connect_errno())
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
            
// Performing SQL query
$query = "SELECT postid, timeline, expiration, userid, subject, message, positioncache, messagecache FROM post WHERE postid = $_GET[postid]";

$result = mysqli_query($link, $query);
                            
if (! $result)
    echo "Query failed: " . mysqli_error($link);

// Printing results in HTML
while ($line = mysql_fetch_array($result, MYSQL_ASSOC)) 
{
    echo "$line[message]";
}

// Free resultset
mysql_free_result($result);

// Closing connection
mysqli_close($link);
?>
